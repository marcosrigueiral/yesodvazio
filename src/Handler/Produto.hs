{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Produto where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /produto                            ProdutoR              GET
-- /produto/cadastrar                  CadastrarProdutoR     GET POST
-- /produto/listar                     ListarProdutoR        GET
-- /produto/buscar/#ProdutoId          BuscarProdutoR        GET
-- /produto/editar/#ProdutoId          EditarProdutoR        PUT
-- /produto/exluir/#ProdutoId          ExcluirProdutoR       POST

-- Produto json
--     nome         Text
--     descricao    Text
--     codigo       Text
--     categoriaid  CategoriaId
--   --  custopadrao  Double  
--     precolista   Double  
--     estoque      Int     
--     datacadastro Day
--     fornecid     FornecedorId
--  --   imagem       Text default = 'default.png'
--     deriving Show

-- formulário de cadastro de Produtos
formProduto :: Form Produto
formProduto = renderDivs $ Produto
    <$> areq textField FieldSettings{fsId=Just "txtNome",
                                     fsLabel="Nome: ",
                                     fsTooltip= Nothing,
                                     fsName= Nothing,
                                     fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtDescricao",
                                      fsLabel="Descrição: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtCodigo",
                                      fsLabel="Código: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] categoriaDescricao) FieldSettings{fsId=Just "txtCategoria",
                                      fsLabel="Categoria: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq doubleField FieldSettings{fsId=Just "txtCusto",
                                      fsLabel="Custo: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq doubleField FieldSettings{fsId=Just "txtPreco",
                                      fsLabel="Preço: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq intField FieldSettings{fsId=Just "txtEstoque",
                                      fsLabel="Estoque: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq dayField FieldSettings{fsId=Just "txtDataCadastro",
                                      fsLabel="Data Cadastro: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] fornecedorNome) FieldSettings{fsId=Just "txtFornecedor",
                                      fsLabel="Fornecedor: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Usuario" Nothing)

getProdutoR :: Handler Html
getProdutoR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Produtos
            <ul>
                <li> <a href=@{CadastrarProdutoR}>  Cadastrar Produtos
                <li> <a href=@{ListarProdutoR}>  Listar Produtos
                <li> <a href=@{ListarProdutoR}>  Listar Produtos
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Produtos utilizando o form criado acima
getCadastrarProdutoR :: Handler Html
getCadastrarProdutoR = do
    (widget,enctype) <- generateFormPost formProduto
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
                        Cadastro de Produtos        
                    <div class="panel-body">
                        <form action=@{CadastrarProdutoR} method=post>
                            ^{widget}
                            <div class="btn-area">
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                        
        |]

postCadastrarProdutoR :: Handler Html 
postCadastrarProdutoR = do
    ((res,_),_) <- runFormPost formProduto
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect ProdutoR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarProdutoR
 

getListarProdutoR :: Handler Html
getListarProdutoR = do 
    -- logado <- lookupSession "_ID"
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
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
                        Listagem de Produtos
                    <table class="table">
                        <thead>
                            <tr>
                                <th> 
                                    Nome
                                <th>
                                    Preco lista
                                <th>
                                    Estoque
                                <th>
                                    
                        <tbody>
                            $forall (Entity pid produto) <- produtos
                                <tr>
                                    <td> 
                                        <a href=@{PerfilProdutoR pid}> 
                                            #{produtoNome produto}
                                    <td>
                                        #{produtoPrecolista produto}
                                    <td>
                                        #{produtoEstoque produto}
                                    <td>
                                        <form action=@{ApagarProdutoR pid} method=post>
                                            <button type="submit" value="" class="btn btn-danger btn-excluir">
                                                Excluir Produto
                                                <span class="glyphicon glyphicon-remove" aria-hidden="true">  
                                        
                        
                        
        |]
        

getBuscarProdutoR :: ProdutoId -> Handler Html
getBuscarProdutoR = error "undefined"

putEditarProdutoR :: ProdutoId -> Handler Html
putEditarProdutoR produtoId = error "undefined" -- do
    --  _ <- runDB $ get404 produtoId
    --  novoProduto <- requireJsonBody :: Handler Produto
    --  runDB $ replace produtoId novoProduto
    --  sendStatusJSON noContent204 (object ["resp" .= ("UPDATED " ++ show (fromSqlKey produtoId))])

postApagarProdutoR :: ProdutoId -> Handler Html
postApagarProdutoR pid = do 
    _ <- runDB $ get404 pid
    runDB $ delete pid 
    redirect ListarProdutoR
    
getPerfilProdutoR :: ProdutoId -> Handler Html
getPerfilProdutoR pid = do
    produto <- runDB $ get404 pid
    defaultLayout $ do 
        [whamlet|
            <h1> Produto #{produtoNome produto}
            <h2> Estoque #{produtoEstoque produto}
            <h2> Preco #{produtoPrecolista produto}
        |]

postPerfilProdutoR :: ProdutoId -> Handler Html
postPerfilProdutoR = error "undefined"