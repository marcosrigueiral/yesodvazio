{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Cliente where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Clientes
formCliente :: Form Cliente
formCliente = renderDivs $ Cliente
    <$> areq textField     "Nome: "  Nothing
    <*> areq textField     "CPF: "   Nothing
    <*> areq emailField    "Email: " Nothing
 -- <*> areq (selectField $ optionsPersistKey [] [] tipoClienteDescricao) "Tipo Cliente: " Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Cliente" Nothing)
    
-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Clientes
getClienteR :: Handler Html
getClienteR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Clientes
            <ul>
                <li> <a href=@{CadastrarClienteR}>  Cadastrar Clientes
                <li> <a href=@{ListarClienteR}>  Listar Clientes
                <li> <a href=@{ListarProdutoR}>  Listar Produtos
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Clientes utilizando o form criado acima
getCadastrarClienteR :: Handler Html
getCadastrarClienteR = do 
    (widget,enctype) <- generateFormPost formCliente
    defaultLayout $ do
        [whamlet|
            <form action=@{CadastrarClienteR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

-- inclusao do formulario preenchido no banco
postCadastrarClienteR :: Handler Html
postCadastrarClienteR = do 
    ((res,_),_) <- runFormPost formCliente
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect ClienteR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarClienteR
 

putEditarClienteR :: ClienteId -> Handler Html
putEditarClienteR = error "undefined"

getBuscarClienteR :: ClienteId -> Handler Html
getBuscarClienteR = error "undefined"

getPerfilClienteR :: ClienteId -> Handler Html
getPerfilClienteR clienteid = do 
    cliente <- runDB $ get404 clienteid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Nome: #{clienteNome cliente}
            <h2>
                CPF: #{clienteCpf cliente} 
            <h2>
                E-mail: #{clienteEmail cliente}
            <a href=@{HomeR}> Voltar
        |]

getListarClienteR :: Handler Html
getListarClienteR = do 
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $ do
        [whamlet| 
            <table>
                <thead>
                    <tr>
                        <th>
                            NOME
                        <th>
                            CPF
                        <th>
                            E-MAIL
                <tbody>
                    $forall (Entity clienteid cliente) <- clientes
                        <tr>
                            <td>
                                <a href=@{PerfilClienteR clienteid}> 
                                    #{clienteNome cliente}
                            
                            <td>
                                #{clienteCpf cliente}
                            
                            <td>
                                #{clienteEmail cliente}
                            <td>
                                <form action=@{ExcluirClienteR clienteid} method=post>
                                    <input type="submit" value="Excluir">
        |]

postExcluirClienteR :: ClienteId -> Handler Html
postExcluirClienteR clienteid = do 
    _ <- runDB $ get404 clienteid
    runDB $ delete clienteid
    redirect ListarClienteR