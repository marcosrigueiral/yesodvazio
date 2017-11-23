{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Database.Persist.Postgresql

-- formLogin :: Form (Text, Text)
-- formLogin = renderDivs $ (,)
--     <$> areq emailField "Email: " Nothing
--     <*> areq passwordField "Senha: " Nothing

-- autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Aluno))
-- autenticar email senha = runDB $ selectFirst [AlunoEmail ==. email
--                                              ,AlunoSenha ==. senha] []
    
getLoginR :: Handler Html
getLoginR = do 
    -- (widget,enctype) <- generateFormPost formLogin
    -- msg <- getMessage
    defaultLayout $ do 
        addStylesheet $ (StaticR css_estilos_css)
        addStylesheet $ (StaticR css_estilosMaster_css)
        addStylesheet $ (StaticR css_estilosGeral_css)
        addStylesheet $ (StaticR css_bootstrap_css)
        $(whamletFile "templates/login.hamlet")

postLoginR :: Handler Html
postLoginR = undefined -- do
--     ((res,_),_) <- runFormPost formLogin
--     case res of 
--         FormSuccess ("root@root.com","root") -> do 
--             setSession "_ID" "admin"
--             redirect AdminR
--         FormSuccess (email,senha) -> do 
--             aluno <- autenticar email senha 
--             case aluno of 
--                 Nothing -> do 
--                     setMessage $ [shamlet| Usuario ou senha invalido |]
--                     redirect LoginR 
--                 Just (Entity aluid aluno) -> do 
--                     setSession "_ID" (alunoNome aluno)
--                     redirect HomeR
--         _ -> redirect HomeR
                

-- postLogoutR :: Handler Html
-- postLogoutR = do 
--     deleteSession "_ID"
--     redirect HomeR