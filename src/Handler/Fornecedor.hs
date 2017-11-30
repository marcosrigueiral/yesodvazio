{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Fornecedor where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /fornecedor                         FornecedorR           GET
-- /fornecedor/cadastrar               CadastrarFornecedorR  GET POST
-- /fornecedor/listar                  ListarFornecedorR     GET
-- /fornecedor/buscar/#FornecedorId    BuscarFornecedorR     GET
-- /fornecedor/editar/#FornecedorId    EditarFornecedorR     PUT
-- /fornecedor/excluir/#FornecedorId   ExcluirFornecedorR    POST

-- Fornecedor json
--     cnpj              Text
--     nomeEmpresa       Text
--     nome              Text  
--     email             Text  
--     telefonecomercial Text  
--     cargo             Text  
--     Uniquecnpj        cnpj
--     deriving Show

-- formulário de Cadastro de Fornecedores
formFornecedor :: Form Fornecedor
formFornecedor = renderDivs $ Fornecedor
    <$> areq textField     "CNPJ: "                 Nothing
    <*> areq textField     "Nome da Empresa: "      Nothing
    <*> areq textField     "Nome do Fornecedor: "   Nothing
    <*> areq emailField    "Email: "                Nothing
    <*> areq textField     "Telefone Comercial: "   Nothing
    <*> areq textField     "Cargo: "                Nothing
    
-- <*> areq (selectField $ optionsPersistKey [] [] tipousuarioDescricao) "Tipo Usuario: " Nothing
-- <*> (fmap toSqlKey $ areq intField "Tipo Usuario" Nothing)

getPerfilFornecedorR :: FornecedorId -> Handler Html
getPerfilFornecedorR fornecedorid = do 
    fornecedor <- runDB $ get404 fornecedorid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Empresa: #{fornecedorNomeEmpresa fornecedor}
            <h2>
                CNPJ: #{fornecedorCnpj fornecedor} 
            <h2>
                Nome: #{fornecedorNome fornecedor}
            <h2>
                E-mail: #{fornecedorEmail fornecedor}
            <h2>
                Tel. Comercial: #{fornecedorEmail fornecedor}
            <h2>
                Cargo: #{fornecedorCargo fornecedor}
            <a href=@{HomeR}> Voltar
        |]

getFornecedorR :: Handler Html
getFornecedorR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Fornecedores
            <ul>
                <li> <a href=@{CadastrarFornecedorR}>  Cadastrar Fornecedor
                <li> <a href=@{ListarFornecedorR}>  Listar Fornecedor
                <li> <a href=@{HomeR}>  Home
        |]

-- essa função pega um formulário (FormFornecedor) e gera um Handler 
-- com uma tupla de "Widget" para campos do formulario e um "enctype" para String.
getCadastrarFornecedorR :: Handler Html
getCadastrarFornecedorR = do
    (widget,enctype) <- generateFormPost formFornecedor
    defaultLayout $ do
        [whamlet|
            <form action=@{CadastrarFornecedorR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]
    
postCadastrarFornecedorR :: Handler Html 
postCadastrarFornecedorR = do
    ((res,_),_) <- runFormPost formFornecedor
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect FornecedorR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarFornecedorR    

getListarFornecedorR :: Handler Html
getListarFornecedorR = do
    fornecedores <- runDB $ selectList [] [Asc FornecedorNomeEmpresa]
    defaultLayout $ do
        [whamlet| 
            <table>
                <thead>
                    <tr>
                        <th>
                            Nome da Empresa
                        <th>
                            CNPJ
                        <th>
                            Representante
                        <th>
                            Cargo
                        <th>
                            E-mail
                        <th>
                            Telefone Comercial
                <tbody>
                    $forall (Entity fornecedorid fornecedor) <- fornecedores
                        <tr>
                            <td>
                                <a href=@{PerfilFornecedorR fornecedorid}> 
                                    #{fornecedorNomeEmpresa fornecedor}
                            <td>
                                #{fornecedorCnpj fornecedor}
                            <td>
                                #{fornecedorNome fornecedor}
                            <td>
                                #{fornecedorCargo fornecedor}
                            <td>
                                #{fornecedorEmail fornecedor}
                            <td>
                                #{fornecedorTelefonecomercial fornecedor}
                            <td>
                                <form action=@{ExcluirFornecedorR fornecedorid} method=post>
                                    <input type="submit" value="Excluir Fornecedor">
        |]

getBuscarFornecedorR :: FornecedorId -> Handler Html
getBuscarFornecedorR = error "undefined"

putEditarFornecedorR :: FornecedorId -> Handler Html
putEditarFornecedorR = error "undefined"

postExcluirFornecedorR :: FornecedorId -> Handler Html
postExcluirFornecedorR = error "undefined"