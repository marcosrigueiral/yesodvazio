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
                                Toggle navigation
                            <span class="icon-bar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                        <a class="navbar-brand" href="#">
                            <img src="../../static/img/logo-2.png" class="logo-menu" />
                    <div id="navbar" class="collapse navbar-collapse">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    Produtos
                                    <span class="caret">
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href=@{CadastrarProdutoR}>
                                            Cadastro de Produtos
                                    <li>
                                        <a href=@{ListarProdutoR}>
                                            Listagem de Produtos
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    Categorias
                                    <span class="caret">
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href=@{CadastrarCategoriaR}>
                                            Cadastro de Categorias
                                    <li>
                                        <a href=@{ListarCategoriaR}>
                                            Listagem de Categorias 
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    Fornecedores
                                    <span class="caret">
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href=@{CadastrarFornecedorR}>
                                            Cadastro de Fornecedores
                                    <li>
                                        <a href=@{ListarFornecedorR}>
                                            Listagem de Fornecedores                                            
                            <li> 
                                <a href=@{UsuarioR}> Cadastro de Usuarios
                                $maybe usuario <- logado
                                    <li>
                                        <form action=@{LogoutR} method=post>
                                            <input type="submit" value="Logout">
                                            
                                $nothing
                                   <li> <a href=@{LoginR}> Login
                                                
            <div class="container">             
                $maybe usuario <- logado
                    <h1> _{MsgBemvindo} #{usuario}
                $nothing
                    <h1> _{MsgBemvindo} _{MsgVisita}            
        |]
