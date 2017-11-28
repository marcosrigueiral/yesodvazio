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
        toWidgetHead [lucius|
            header{
                
                width:100%;
                background-color:#000000;
                height:60px;
            }
            ul{
                background-color:red;
                float:left;
                width:100%;
            }
            
            h1{
                color: green;
            }
            
            li{
                display: inline-block;
                list-style:  none;
                background-color: #000000;
            }
            
        |]
    
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
