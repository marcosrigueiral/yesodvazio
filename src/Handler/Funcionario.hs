{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Funcionario where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Funcionarios
formFuncionario :: Form Funcionario
formFuncionario = renderDivs $ Funcionario
    <$> areq textField FieldSettings{fsId=Just "txtNome",
                                      fsLabel="Nome: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtCPF",
                                      fsLabel="CPF: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq emailField FieldSettings{fsId=Just "txtEmail",
                                      fsLabel="E-mail: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq passwordField FieldSettings{fsId=Just "txtSenha",
                                      fsLabel="Senha: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
 -- <*> areq (selectField $ optionsPersistKey [] [] tipoFuncionarioDescricao) "Tipo Funcionario: " Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Funcionario" Nothing)
    
-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Funcionarios
getFuncionarioR :: Handler Html
getFuncionarioR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Funcionarios
            <ul>
                <li> <a href=@{CadastrarFuncionarioR}>  Cadastrar Funcionarios
                <li> <a href=@{ListarFuncionarioR}>  Listar Funcionarios
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Funcionarios utilizando o form criado acima
getCadastrarFuncionarioR :: Handler Html
getCadastrarFuncionarioR = do 
    (widget,enctype) <- generateFormPost formFuncionario
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
                        Cadastro de Funcionários        
                    <div class="panel-body">             
                        <form action=@{CadastrarFuncionarioR} method=post>
                            ^{widget}
                            <div class="btn-area">                            
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                            
        |]

-- inclusao do formulario preenchido no banco
postCadastrarFuncionarioR :: Handler Html
postCadastrarFuncionarioR = do 
    ((res,_),_) <- runFormPost formFuncionario
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect FuncionarioR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarFuncionarioR
 

putEditarFuncionarioR :: FuncionarioId -> Handler Html
putEditarFuncionarioR = error "undefined" -- do
    -- _ <- runDB $ get404 funcionarioId
    -- novoFuncionario <- requireJsonBody :: Handler Funcionario
    -- runDB $ replace funcionarioId novoFuncionario
    -- sendStatusJSON noContent204 (object ["resp" .= ("UPDATED " ++ show (fromSqlKey funcionarioId))])

getBuscarFuncionarioR :: FuncionarioId -> Handler Html
getBuscarFuncionarioR = error "undefined"

getPerfilFuncionarioR :: FuncionarioId -> Handler Html
getPerfilFuncionarioR funcionarioid = do 
    funcionario <- runDB $ get404 funcionarioid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Nome: #{funcionarioNome funcionario}
            <h2>
                CPF: #{funcionarioCpf funcionario} 
            <h2>
                E-mail: #{funcionarioEmail funcionario}
            <a href=@{HomeR}> Voltar
        |]

getListarFuncionarioR :: Handler Html
getListarFuncionarioR = do 
    funcionarios <- runDB $ selectList [] [Asc FuncionarioNome]
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
                        <span class="glyphicon glyphicon-th-list" aria-hidden="true">
                        Listagem de Funcionários  
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
                            $forall (Entity funcionarioid funcionario) <- funcionarios
                                <tr>
                                    <td>
                                        <a href=@{PerfilFuncionarioR funcionarioid}> 
                                            #{funcionarioNome funcionario}
                                    
                                    <td>
                                        #{funcionarioCpf funcionario}
                                    
                                    <td>
                                        #{funcionarioEmail funcionario}
                                    <td>
                                        <form action=@{ExcluirFuncionarioR funcionarioid} method=post>
                                            <input type="submit" value="Excluir">
        |]

postExcluirFuncionarioR :: FuncionarioId -> Handler Html
postExcluirFuncionarioR funcionarioid = do 
    _ <- runDB $ get404 funcionarioid
    runDB $ delete funcionarioid
    redirect ListarFuncionarioR