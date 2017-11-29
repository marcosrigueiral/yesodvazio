{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    logado <- lookupSession "_ID"
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_css)
        --corpo html
        -- $(whamletFile "templates/home.hamlet")
    
        [whamlet|
            <header>
                <li> 
                    <a href=@{UsuarioR}> Cadastro de Usuario
                    $maybe usuario <- logado
                        <li> 
                            <form action=@{LogoutR} method=post>
                                <input type="submit" value="Logout">
                    $nothing
                        <li> <a href=@{LoginR}> Login
                                
                    $maybe usuario <- logado
                        <h1> _{MsgBemvindo} - #{usuario}
                    $nothing
                        <h1> _{MsgBemvindo} _{MsgVisita}
                    <ul>
                    
        |]
