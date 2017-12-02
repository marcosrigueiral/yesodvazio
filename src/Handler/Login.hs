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
    <$> areq emailField FieldSettings{fsId=Just "txtEmail",
                                      fsLabel=" ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("placeholder","E-mail"), ("class","form-control")]} Nothing
    <*> areq passwordField FieldSettings{fsId=Just "txtSenha",
                                      fsLabel=" ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("placeholder","Senha"), ("class","form-control")]} Nothing

-- formLogin :: Form (Text, Text)
-- formLogin = renderBootstrap $ (,)
--     <$> areq emailField (bootstrapFieldSettings config "Email" Nothing (Just "Person name") Nothing Nothing) Nothing
--     <*> areq passwordField (bootstrapFieldSettings config "Senha" Nothing (Just "Person name") Nothing Nothing) Nothing

autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Usuario))
autenticar email senha = runDB $ selectFirst [UsuarioEmail ==. email
                                             ,UsuarioSenha ==. senha] []
                                             
                                            
-- funcao de autentificaçao de funcionario
-- autenticarFunc :: Text -> Text -> HandlerT App IO (Maybe (Entity Funcionario))
-- autenticarFunc email senha = runDB $ selectFirst [UsuarioEmailf ==. email
--                                              ,UsuarioSenhaf ==. senha] []

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
        addStylesheet $ (StaticR css_bootstrap_css)    
        toWidget [lucius|
            body
            {
                background-color: #222222;
            }
            .login-area
            {
                max-width: 330px !important;
                margin: 0 auto !important;
                position: absolute !important;
                top: 50% !important;
                left: 50% !important;
                transform: translate(-50%,-50%) !important;
            }
            
            .btn-login
            {
                width:100%;
            }
            
            .center
            {
                text-align: center;
            }
            
            .logo-principal 
            {
                display: inline-block;
                max-width: 90%;
                margin-top: 20px;
            }
        |]
        [whamlet|
            $maybe mensa <- msg 
                <h1> Usuário Inválido !!!
            <div class="thumbnail login-area">   
                <div class="caption">   
                    <div class="center">   
                        <img src="../../static/img/logo-1.png" class="logo-principal">
                    <form action=@{LoginR} method=post>
                        ^{widget}
                        <br>
                        <input type="submit" value="Entrar" class="btn btn-success btn-login">  
        |]
                
-- autentica os dados recebidos pelo form 
postLoginR :: Handler Html
postLoginR = do
    ((res,_),_) <- runFormPost formLogin
    case res of 
        FormSuccess (email,senha) -> do 
            usuario <- autenticar email senha 
            case usuario of 
                Nothing -> do 
                    setMessage $ [shamlet| Usuário ou senha inválido !!! |]
                    redirect LoginR 
                Just (Entity usuarioId usuario) -> do 
                    setSession "_ID" (usuarioNome usuario)
                    redirect HomeR
        _ -> redirect HomeR
    
    
-- autentifica os dados recebidos pelo form 
-- postLoginR :: Handler Html
-- postLoginR = do
--     ((res,_),_) <- runFormPost formLogin -- recebe a resposta do form
--     case res of 
--         FormSuccess ("root@root.com","root") -> do 
--             setSession "_Adm" "admin"
--             redirect HomeR
--         FormSuccess (email,senha) -> do 
--             func <- autenticarFunc email senha -- pega a resposta do form, executa o autenticar
--             case func of 
--                 Just (Entity funcid func) -> do -- se a autentificaçao for sucesso
--                     setSession "_Usuario" (funcionarioNm_funcionario func)
--                     redirect HomeR
--                 Nothing -> do
--                     setMessage $ [shamlet| Usuario ou senha invalido |] -- se a autentificaçao falhar
--                     redirect LoginR
--         _ -> redirect HomeR
                
-- desloga da sessao devolvendo pra home 
postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_ID"
    redirect HomeR
 
-- postLogoutR :: Handler Html
-- postLogoutR = do 
--     lookupLogin >>= deleteSession 
--     redirect HomeR