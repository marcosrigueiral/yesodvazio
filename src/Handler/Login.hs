{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Login where

import Import
import Database.Persist.Postgresql
import Yesod.Form.Bootstrap3

formLogin :: Form (Text, Text)
formLogin = renderBootstrap $ (,)
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

-- formLogin :: Form (Text, Text)
-- formLogin = renderBootstrap $ (,)
--     <$> areq emailField (bootstrapFieldSettings config "Email" Nothing (Just "Person name") Nothing Nothing) Nothing
--     <*> areq passwordField (bootstrapFieldSettings config "Senha" Nothing (Just "Person name") Nothing Nothing) Nothing

autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Usuario))
autenticar email senha = runDB $ selectFirst [UsuarioEmail ==. email
                                             ,UsuarioSenha ==. senha] []

-- getLoginR :: Handler Html
-- getLoginR = do 
--     -- (widget,enctype) <- generateFormPost formLogin
--     -- msg <- getMessage
--     defaultLayout $ do
--         addStylesheet $ (StaticR css_estilos_css)
--         addStylesheet $ (StaticR css_estilosMaster_css)
--         addStylesheet $ (StaticR css_estilosGeral_css)
--         addStylesheet $ (StaticR css_bootstrap_css)
--         $(whamletFile "templates/login.hamlet")

-- executa o formulario recebendo os dados de login
getLoginR :: Handler Html
getLoginR = do 
    (widget, enctype) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do
        toWidget [lucius|
            form
            {
                width:300px !important;
                margin:0 auto !important;
            }
        |]
        [whamlet|
            $maybe mensa <- msg 
                <h1> Usuario Invalido
            <form action=@{LoginR} method=post>
                ^{widget}
                <input type="submit" value="Login">  
        |]
                
-- autentifica os dados recebidos pelo form 
postLoginR :: Handler Html
postLoginR = do
    ((res,_),_) <- runFormPost formLogin
    case res of 
        FormSuccess (email,senha) -> do 
            usuario <- autenticar email senha 
            case usuario of 
                Nothing -> do 
                    setMessage $ [shamlet| Usuario ou senha invalido |]
                    redirect LoginR 
                Just (Entity usuarioId usuario) -> do 
                    setSession "_ID" (usuarioNome usuario)
                    redirect HomeR
        _ -> redirect HomeR
    
                
-- desloga da sessao devolvendo pra home 
postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_ID"
    redirect HomeR
 
-- postLogoutR :: Handler Html
-- postLogoutR = do 
--     lookupLogin >>= deleteSession 
--     redirect HomeR
    
