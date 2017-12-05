{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Fornecedor where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /fornecedor                         FornecedorR           GET
-- /fornecedor/cadastrar               CadastrarFornecedorR  GET POST
-- /fornecedor/listar                  ListarFornecedorR     GET
-- /fornecedor/buscar/#FornecedorId    BuscarFornecedorR     GET
-- /fornecedor/editar/#FornecedorId    EditarFornecedorR     PUT
-- /fornecedor/excluir/#FornecedorId   ExcluirFornecedorR    POST

-- Fornecedor json
--     cnpj              Text
--     nomeEmpresa       Text
--     nome              Text  
--     email             Text  
--     telefonecomercial Text  
--     cargo             Text  
--     Uniquecnpj        cnpj
--     deriving Show

-- formulário de Cadastro de Fornecedores
formFornecedor :: Form Fornecedor
formFornecedor = renderDivs $ Fornecedor
    <$> areq textField FieldSettings{fsId=Just "txtCNPJ",
                                      fsLabel="CNPJ: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtNomeEmpresa",
                                      fsLabel="Nome da Empresa: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
     <*> areq textField FieldSettings{fsId=Just "txtNome",
                                      fsLabel="Nome: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq emailField FieldSettings{fsId=Just "txtEmail",
                                      fsLabel="E-mail: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtTelComercial",
                                      fsLabel="Telefone Comercial: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtCargo",
                                      fsLabel="Cargo: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    
    
-- <*> areq (selectField $ optionsPersistKey [] [] tipousuarioDescricao) "Tipo Usuario: " Nothing
-- <*> (fmap toSqlKey $ areq intField "Tipo Usuario" Nothing)

getPerfilFornecedorR :: FornecedorId -> Handler Html
getPerfilFornecedorR fornecedorid = do 
    fornecedor <- runDB $ get404 fornecedorid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Empresa: #{fornecedorNomeEmpresa fornecedor}
            <h2>
                CNPJ: #{fornecedorCnpj fornecedor} 
            <h2>
                Nome: #{fornecedorNome fornecedor}
            <h2>
                E-mail: #{fornecedorEmail fornecedor}
            <h2>
                Tel. Comercial: #{fornecedorEmail fornecedor}
            <h2>
                Cargo: #{fornecedorCargo fornecedor}
            <a href=@{HomeR}> Voltar
        |]

getFornecedorR :: Handler Html
getFornecedorR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Fornecedores
            <ul>
                <li> <a href=@{CadastrarFornecedorR}>  Cadastrar Fornecedor
                <li> <a href=@{ListarFornecedorR}>  Listar Fornecedor
                <li> <a href=@{HomeR}>  Home
        |]

-- essa função pega um formulário (FormFornecedor) e gera um Handler 
-- com uma tupla de "Widget" para campos do formulario e um "enctype" para String.
getCadastrarFornecedorR :: Handler Html
getCadastrarFornecedorR = do
    (widget,enctype) <- generateFormPost formFornecedor
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
                                            <a href=@{CadastrarFuncionarioR}>
                                                Cadastro de Funcionários
                                        <li>
                                            <a href=@{ListarFuncionarioR}>
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
                        Cadastro de Fornecedores        
                    <div class="panel-body">
                        <form action=@{CadastrarFornecedorR} method=post>
                            ^{widget}
                            <div class="btn-area">
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                        
        |]
    
postCadastrarFornecedorR :: Handler Html 
postCadastrarFornecedorR = do
    ((res,_),_) <- runFormPost formFornecedor
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect FornecedorR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarFornecedorR    

getListarFornecedorR :: Handler Html
getListarFornecedorR = do
    fornecedores <- runDB $ selectList [] [Asc FornecedorNomeEmpresa]
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
            .btn-excluir 
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
                                            <a href=@{CadastrarFuncionarioR}>
                                                Cadastro de Funcionários
                                        <li>
                                            <a href=@{ListarFuncionarioR}>
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
                        Listagem de Fornecedores
        
                    <table>
                        <thead>
                            <tr>
                                <th>
                                    Nome da Empresa
                                <th>
                                    CNPJ
                                <th>
                                    Representante
                                <th>
                                    Cargo
                                <th>
                                    E-mail
                                <th>
                                    Telefone Comercial
                        <tbody>
                            $forall (Entity fornecedorid fornecedor) <- fornecedores
                                <tr>
                                    <td>
                                        <a href=@{PerfilFornecedorR fornecedorid}> 
                                            #{fornecedorNomeEmpresa fornecedor}
                                    <td>
                                        #{fornecedorCnpj fornecedor}
                                    <td>
                                        #{fornecedorNome fornecedor}
                                    <td>
                                        #{fornecedorCargo fornecedor}
                                    <td>
                                        #{fornecedorEmail fornecedor}
                                    <td>
                                        #{fornecedorTelefonecomercial fornecedor}
                                    <td>
                                        <form action=@{ExcluirFornecedorR fornecedorid} method=post>
                                            <button type="submit" vale="" class="btn btn-danger btn-excluir">
                                                Excluir Fornecedor
                                                <span class="glyphicon glyphicon-remove" aria-hidden="true">                                                                    
        |]

getBuscarFornecedorR :: FornecedorId -> Handler Html
getBuscarFornecedorR = error "undefined"

putEditarFornecedorR :: FornecedorId -> Handler Html
putEditarFornecedorR = error "undefined"

postExcluirFornecedorR :: FornecedorId -> Handler Html
postExcluirFornecedorR = error "undefined"