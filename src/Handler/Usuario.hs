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
                <li> <a href=@{CadastrarUsuarioR}>  Cadastrar Usuario
                <li> <a href=@{ListarUsuarioR}>  Listar Usuarios
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
 

getListarUsuarioR :: Handler Html
getListarUsuarioR = error "undefined"

putEditarUsuarioR :: UsuarioId -> Handler Html
putEditarUsuarioR = error "undefined"

getBuscarUsuarioR :: UsuarioId -> Handler Html
getBuscarUsuarioR = error "undefined"

postExcluirUsuarioR :: UsuarioId -> Handler Html
postExcluirUsuarioR = error "undefined"