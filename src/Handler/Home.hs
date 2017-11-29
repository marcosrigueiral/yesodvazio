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
        --addStylesheet $ (StaticR css_temas_css)
        addScript $ (StaticR js_jquery_min_js)
        addScript $ (StaticR js_bootstrap_min_js)
        --corpo html
        -- $(whamletFile "templates/home.hamlet")
        toWidget [lucius|
            .logo-menu 
            {
                float: left;
                width: 140px;
                margin-top: -10px;
            }

        |]    
        [whamlet|
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <nav class="navbar navbar-inverse">
                <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                            <span class="sr-only">
                                Cadastro de Produto
                            <span class="icon-bar">
                                Cadastro de Categoria
                            <span class="icon-bar">
                                Listagem de Produto
                            <span class="icon-bar">
                                Listagem de Categoria
                        <a class="navbar-brand" href="#">
                            <img src="../../static/img/logo-2.png" class="logo-menu" />
                    <div id="navbar" class="collapse navbar-collapse">
                        <ul class="nav navbar-nav">
                            <li>
                                <a href="#">
                                    Cadastro de Produto
                            <li>
                                <a href="#">
                                    Cadastro de Categoria
                            <li>
                                <a href="#">
                                    Listagem de Produto
                            <li>
                                <a href="#">
                                    Listagem de Categoria
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
