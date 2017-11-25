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
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        
        [whamlet|
            $maybe usuario <- logado
                <h1> _{MsgBemvindo} #{usuario}
            $nothing
                <h1> _{MsgBemvindo} _{MsgVisita}
            <ul>
                <li> <a href=@{UsuarioR}> Cadastro de Usuario
                $maybe usuario <- logado
                    <li> 
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Logout">
                $nothing
                    <li> <a href=@{LoginR}> Login
        |]
