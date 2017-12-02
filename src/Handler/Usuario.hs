{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Usuario where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Usuarios
formUsuario :: Form Usuario
formUsuario = renderDivs $ Usuario
    <$> areq textField     "Nome: "  Nothing
    <*> areq textField     "CPF: "   Nothing
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing
    <*> areq (selectField $ optionsPersistKey [] [] tipousuarioDescricao) "Tipo Usuario: " Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Usuario" Nothing)
    
-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Usuarios
getUsuarioR :: Handler Html
getUsuarioR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Usuarios
            <ul>
                <li> <a href=@{CadastrarUsuarioR}>  Cadastrar Usuários
                <li> <a href=@{CadastrarProdutoR}>  Cadastrar Produtos
                <li> <a href=@{ListarUsuarioR}>  Listar Usuários
                <li> <a href=@{ListarProdutoR}>  Listar Produtos
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Usuarios utilizando o form criado acima
getCadastrarUsuarioR :: Handler Html
getCadastrarUsuarioR = do 
    (widget,enctype) <- generateFormPost formUsuario
    defaultLayout $ do
        [whamlet|
            <form action=@{CadastrarUsuarioR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

-- inclusao do formulario preenchido no banco
postCadastrarUsuarioR :: Handler Html
postCadastrarUsuarioR = do 
    ((res,_),_) <- runFormPost formUsuario
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect UsuarioR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarUsuarioR
 

putEditarUsuarioR :: UsuarioId -> Handler Html
putEditarUsuarioR = error "undefined"

getBuscarUsuarioR :: UsuarioId -> Handler Html
getBuscarUsuarioR = error "undefined"

getPerfilUsuarioR :: UsuarioId -> Handler Html
getPerfilUsuarioR usuarioid = do 
    usuario <- runDB $ get404 usuarioid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Nome: #{usuarioNome usuario}
            <h2>
                CPF: #{usuarioCpf usuario} 
            <h2>
                E-mail: #{usuarioEmail usuario}
            <a href=@{HomeR}> Voltar
        |]

getListarUsuarioR :: Handler Html
getListarUsuarioR = do 
    usuarios <- runDB $ selectList [] [Asc UsuarioNome]
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
                    $forall (Entity usuarioid usuario) <- usuarios
                        <tr>
                            <td>
                                <a href=@{PerfilUsuarioR usuarioid}> 
                                    #{usuarioNome usuario}
                            
                            <td>
                                #{usuarioCpf usuario}
                            
                            <td>
                                #{usuarioEmail usuario}
                            
                            <td>
                                <form action=@{ExcluirUsuarioR usuarioid} method=post>
                                    <input type="submit" value="Excluir">
        |]

postExcluirUsuarioR :: UsuarioId -> Handler Html
postExcluirUsuarioR usuarioid = do 
    _ <- runDB $ get404 usuarioid
    runDB $ delete usuarioid
    redirect ListarUsuarioR