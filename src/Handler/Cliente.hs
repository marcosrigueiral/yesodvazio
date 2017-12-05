{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Cliente where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Clientes
formCliente :: Form Cliente
formCliente = renderDivs $ Cliente
    <$> areq textField  FieldSettings{fsId=Just "txtNome",
                                      fsLabel="Nome: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField  FieldSettings{fsId=Just "txtCPF",
                                      fsLabel="CPF: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq emailField   FieldSettings{fsId=Just "txtEmail",
                                      fsLabel="E-mail: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
 -- <*> areq (selectField $ optionsPersistKey [] [] tipoClienteDescricao) "Tipo Cliente: " Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Cliente" Nothing)
    
-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Clientes
getClienteR :: Handler Html
getClienteR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Clientes
            <ul>
                <li> <a href=@{CadastrarClienteR}>  Cadastrar Clientes
                <li> <a href=@{ListarClienteR}>  Listar Clientes
                <li> <a href=@{ListarProdutoR}>  Listar Produtos
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Clientes utilizando o form criado acima
getCadastrarClienteR :: Handler Html
getCadastrarClienteR = do 
    (widget,enctype) <- generateFormPost formCliente
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
            .btn-sair 
            {
                float: right;
                margin-top: 8px;
            }
            .required
            {
                width: 200px;
                float: left;
                padding: 10px;
            }
            .btn-area
            {
                width: 100%;
                float: left;
            }
            .btn-enviar
            {
                float: right;
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
                            <a class="navbar-brand" href=@{HomeR}>
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
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Funcionários
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarUsuarioR}>
                                                Cadastro de Funcionários
                                        <li>
                                            <a href=@{ListarUsuarioR}>
                                                Listagem de Funcionários  
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Clientes
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarClienteR}>
                                                Cadastro de Clientes
                                        <li>
                                            <a href=@{ListarClienteR}>
                                                Listagem de Clientes  
                                
                                <li>
                                    <form action=@{LogoutR} method=post>
                                        <button type="submit" value="" class="btn btn-danger btn-sair">
                                            Sair
                                            <span class="glyphicon glyphicon-remove" aria-hidden="true">                             
                                            
                                                
            <div class="container">   
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="glyphicon glyphicon-download-alt" aria-hidden="true">
                        Cadastro de Clientes        
                    <div class="panel-body">                
                        <form action=@{CadastrarClienteR} method=post>
                            ^{widget}
                            <div class="btn-area">                            
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                            
        |]

-- inclusao do formulario preenchido no banco
postCadastrarClienteR :: Handler Html
postCadastrarClienteR = do 
    ((res,_),_) <- runFormPost formCliente
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect ClienteR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarClienteR
 

putEditarClienteR :: ClienteId -> Handler Html
putEditarClienteR = error "undefined"

getBuscarClienteR :: ClienteId -> Handler Html
getBuscarClienteR = error "undefined"

getPerfilClienteR :: ClienteId -> Handler Html
getPerfilClienteR clienteid = do 
    cliente <- runDB $ get404 clienteid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Nome: #{clienteNome cliente}
            <h2>
                CPF: #{clienteCpf cliente} 
            <h2>
                E-mail: #{clienteEmail cliente}
            <a href=@{HomeR}> Voltar
        |]

getListarClienteR :: Handler Html
getListarClienteR = do 
    clientes <- runDB $ selectList [] [Asc ClienteNome]
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
            .btn-sair 
            {
                float: right;
                margin-top: 8px;
            }
            .required
            {
                width: 200px;
                float: left;
                padding: 10px;
            }
            .btn-area
            {
                width: 100%;
                float: left;
            }
            .btn-excluir 
            {
                float: right;
            }              
            .btn-enviar
            {
                float: right;
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
                            <a class="navbar-brand" href=@{HomeR}>
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
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Funcionários
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarUsuarioR}>
                                                Cadastro de Funcionários
                                        <li>
                                            <a href=@{ListarUsuarioR}>
                                                Listagem de Funcionários  
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Clientes
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarClienteR}>
                                                Cadastro de Clientes
                                        <li>
                                            <a href=@{ListarClienteR}>
                                                Listagem de Clientes  
                                
                                <li>
                                    <form action=@{LogoutR} method=post>
                                        <button type="submit" value="" class="btn btn-danger btn-sair">
                                            Sair
                                            <span class="glyphicon glyphicon-remove" aria-hidden="true">                       
                                            
                                                
            <div class="container">   
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="glyphicon glyphicon-th-list" aria-hidden="true">
                        Listagem de Clientes 
                    <table class="table">        
                        <thead>
                            <tr>
                                <th>
                                    NOME
                                <th>
                                    CPF
                                <th>
                                    E-MAIL
                        <tbody>
                            $forall (Entity clienteid cliente) <- clientes
                                <tr>
                                    <td>
                                        <a href=@{PerfilClienteR clienteid}> 
                                            #{clienteNome cliente}
                                    
                                    <td>
                                        #{clienteCpf cliente}
                                    
                                    <td>
                                        #{clienteEmail cliente}
                                    <td>
                                        <form action=@{ExcluirClienteR clienteid} method=post>
                                            <button type="submit" value="" class="btn btn-danger btn-excluir">
                                                Excluir Categoria
                                                <span class="glyphicon glyphicon-remove" aria-hidden="true">  
        |]

postExcluirClienteR :: ClienteId -> Handler Html
postExcluirClienteR clienteid = do 
    _ <- runDB $ get404 clienteid
    runDB $ delete clienteid
    redirect ListarClienteR