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
            *
            {
                margin:0;
                padding:0;
                border:none;
                text-decoration:none;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                box-sizing:border-box;
                outline:none
            }
            
            form
            {
                width:100%
            }
            
            .center
            {
                text-align:center
            }
            
            .container
            {
                width:100%;
                max-width:998px;
                clear:both;
                margin:0 auto;
                padding:0;
                list-style:none;
                display:-webkit-box;
                display:-moz-box;
                display:-ms-flexbox;
                display:-webkit-flex;
                display:flex;
                flex-flow:row wrap;
                justify-content:space-between;
                align-items:stretch;
                align-content:stretch
            }
            
            .container .container
            {
                width:100%;
                max-width:unset;
                padding:0;
                float:right
            }
            
            .fluido
            {
                max-width:100%;
                padding:0 0
            }
            
            .no-padding
            {
                padding:0
            }
            
            a:link,a:visited
            {
                -moz-transition:.5s ease;
                -o-transition:.5s ease;
                -webkit-transition:.5s ease;
                transition:.5s ease
            }
            
            a:hover,a:active{}
            .direita
            {
                float:right;
                margin-right:0!important
            }
            .esquerda
            {
                float:left;
                margin-left:0!important
            }
            
            .clear
            {
                clear:both;
                margin:0!important
            }
            
            .flex-item
            {
                flex-shrink:1;
                flex-grow:0;
                flex-basis:auto
            }
            
            .flex-item .flex-item
            {
                flex-grow:0
            }
            
            [data-cell~="1"]
            {
                flex-basis:8.333%
            }
            
            [data-cell~="2"]
            {
                flex-basis:16.66%
            }
            
            [data-cell~="3"]{flex-basis:25%}
            [data-cell~="4"]{flex-basis:33.333%}
            [data-cell~="5"]{flex-basis:41.66%}
            [data-cell~="6"]{flex-basis:50%}
            [data-cell~="7"]{flex-basis:58.33%}
            [data-cell~="8"]{flex-basis:66.66%}
            [data-cell~="9"]{flex-basis:75%}
            [data-cell~="10"]{flex-basis:83.33%}
            [data-cell~="11"]{flex-basis:91.66%}
            [data-cell~="12"]{flex-basis:100%}
            .largura{width:47%}
            .no-mobile{display:block}
            .no-desktop{display:none!important}
            .center-mobile{text-align:unset}
            @media(min-width:767px)and (max-width:1024px)
            {
                .container{padding:0 10px}
                .container .container{padding:0}
                [data-item~="noticias"] [data-cell~="3"]{width:33%}
                [data-item~="noticia-principal"] [data-cell~="3"]{width:20%}
                [data-item~="noticia-principal"] [data-cell~="9"]{width:80%}
            }
            @media(max-width:767px){
                .no-mobile{display:none!important}
                .no-desktop{display:block!important}
                .container{width:90%;padding:0 0;flex-flow:column wrap}
                [data-cell~="1"],[data-cell~="2"],
                [data-cell~="3"],[data-cell~="4"],
                [data-cell~="5"],[data-cell~="6"],
                [data-cell~="7"],[data-cell~="8"],
                [data-cell~="9"],[data-cell~="10"],
                [data-cell~="11"],[data-cell~="12"]
                {flex-basis:100%}
                .fluido{width:100%;padding:0 0}
                .center-mobile{text-align:center}
                .container .container{width:100%}
                }        
        
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
