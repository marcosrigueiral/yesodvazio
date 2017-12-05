{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Pedido where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- Pedido json
--     cliid          ClienteId
--     endid          EnderecoId
--     proid          ProdutoId     
--     formapagid     FormapagamentoId
--     dataPedido     DayformPedido :: Form Pedido

-- formulário de cadastro de Pedidos
formPedido :: Form Pedido
formPedido = renderDivs $ Pedido
    <$> areq (selectField $ optionsPersistKey [] [] clienteNome) FieldSettings{fsId=Just "txtCliente",
                                      fsLabel="Cliente: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq (selectField $ optionsPersistKey [] [] enderecoLogradouro) FieldSettings{fsId=Just "txtEndereco",
    --                                   fsLabel="Endereco: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] produtoNome) FieldSettings{fsId=Just "txtProduto",
                                      fsLabel="Produto: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] formapagamentoDescricao) FieldSettings{fsId=Just "txtFormapagamento",
                                      fsLabel="Forma de Pagamento: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq dayField FieldSettings{fsId=Just "txtDataPedido",
                                      fsLabel="Data Pedido: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq intField FieldSettings{fsId=Just "txtQuant",
                                      fsLabel="Quantidade: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    
-- getFuncionarioR :: Handler TypedContent
-- getFuncionarioR = do
--     funcionario <- (runDB $ selectList [FuncionarioExcluido ==. False][Asc FuncionarioNome]) :: Handler [Entity Funcionario]
--     sendStatusJSON created201 $ object["Funcionario" .= funcionario]

-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Pedidos
getPedidoR :: Handler Html
getPedidoR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
        |]
        [whamlet|
            <h1> Pedido
            <ul>
                <li> <a href=@{CadastrarPedidoR}>  Cadastrar Pedidos
                <li> <a href=@{ListarPedidoR}>  Listar Pedidos
                <li> <a href=@{HomeR}>  Home
        |]


-- preenchimento de formulario para cadastro de Funcionarios utilizando o form criado acima
getCadastrarPedidoR :: Handler Html
getCadastrarPedidoR = do 
    (widget,enctype) <- generateFormPost formPedido
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_css)
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
                                        Pedidos
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarPedidoR}>
                                                Cadastro de Pedidos
                                        <li>
                                            <a href=@{ListarPedidoR}>
                                                Listagem de Pedidos
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
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Carrinho de Compras&nbsp;
                                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true">
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarPedidoR}>
                                                Cadastro de Pedidos
                                        <li>
                                            <a href=@{ListarPedidoR}>
                                                Listagem de Pedidos  
                                
                                <li>
                                    <form action=@{LogoutR} method=post>
                                        <button type="submit" value="" class="btn btn-danger btn-sair">
                                            Sair
                                            <span class="glyphicon glyphicon-remove" aria-hidden="true">                        
            <div class="container">   
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="glyphicon glyphicon-download-alt" aria-hidden="true">
                        Cadastro de Pedidos        
                    <div class="panel-body">             
                        <form action=@{CadastrarPedidoR} method=post>
                            ^{widget}
                            <div class="btn-area">                            
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                            
        |]

getBuscarPedidoR :: PedidoId -> Handler Html
getBuscarPedidoR = error "undefined"

-- getFuncionarioIdR :: FuncionarioId -> Handler TypedContent
-- getFuncionarioIdR funcionarioId = do
--     funcionario <- runDB $ get404 funcionarioId
--     cidade <- runDB $ get404 $ funcionarioCidadeId funcionario
--     estado <- runDB $ get404 $ funcionarioEstadoId $  funcionario
--     sendStatusJSON ok200 $ object ["Funcionario" .= funcionario, "Cidade" .= cidade, "Estado" .= estado]


-- inclusao do formulario preenchido no banco
postCadastrarPedidoR :: Handler Html
postCadastrarPedidoR = do 
    ((res,_),_) <- runFormPost formPedido
    case res of 
        FormSuccess ped -> do
            _ <- runDB $ insert ped
            redirect PedidoR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarPedidoR

putEditarPedidoR :: PedidoId -> Handler Html
putEditarPedidoR = error "undefined"
-- putEditarFuncionarioR :: FuncionarioId -> Handler Html
-- putEditarFuncionarioR = error "undefined" -- do
    -- _ <- runDB $ get404 funcionarioId
    -- novoFuncionario <- requireJsonBody :: Handler Funcionario
    -- runDB $ replace funcionarioId novoFuncionario
    -- sendStatusJSON noContent204 (object ["resp" .= ("UPDATED " ++ show (fromSqlKey funcionarioId))])

-- getPerfilPedidoR :: PedidoId -> Handler Html
-- getPerfilPedidoR pedidoid = do 
--     pedido <- runDB $ get404 pedidoid
--     defaultLayout $ do 
--         [whamlet|
--             <h1> 
--                 Nome: #{pedidoCliid pedido}
--             <h2>
--                 Produto: #{pedidoProid pedido} 
--             <h2>
--                 Data do Pedido: #{pedidoDataPedido pedido}
--             <a href=@{HomeR}> Voltar
--        |]

getListarPedidoR :: Handler Html
getListarPedidoR = do 
    pedidos <- runDB $ selectList [] [Asc PedidoId]
    pedidoscli <- runDB $ mapM (get404 . pedidoCliid . entityVal) pedidos 
    pedidosprod <- runDB $ mapM (get404 . pedidoProid . entityVal) pedidos 
    let lista = zip3 pedidos pedidoscli pedidosprod
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_css)
        --addStylesheet $ (StaticR css_temas_css)
        addScript $ (StaticR js_jquery_min_js)
        addScript $ (StaticR js_bootstrap_min_js)
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
                                                
                                <li class="dropdown">
                                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                        Carrinho de Compras&nbsp;
                                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true">
                                        <span class="caret">
                                    <ul class="dropdown-menu">
                                        <li>
                                            <a href=@{CadastrarPedidoR}>
                                                Cadastro de Pedidos
                                        <li>
                                            <a href=@{ListarPedidoR}>
                                                Listagem de Pedidos  
                                
                                <li>
                                    <form action=@{LogoutR} method=post>
                                        <button type="submit" value="" class="btn btn-danger btn-sair">
                                            Sair
                                            <span class="glyphicon glyphicon-remove" aria-hidden="true">                        
                      
                                            
                                                
            <div class="container">   
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="glyphicon glyphicon-th-list" aria-hidden="true">
                        Listagem de Pedidos
                    <table class="table">
                        <thead>
                            <tr>
                                <th> 
                                    Nome do cliente
                                <th>
                                    Produto
                                <th>
                                    Quantidade
                                <th>
                        <tbody>
                            $forall ((Entity pedid pedido), cliente, produto) <- lista
                                <tr>
                                    <td> 
                                        
                                        #{clienteNome cliente}
                                    <td>
                                        #{produtoNome produto}
                                    <td>
                                        #{pedidoQuant pedido}
                                    <td>
                                        <form action=@{ExcluirPedidoR pedid} method=post>
                                            <button type="submit" value="" class="btn btn-danger btn-excluir">
                                                Excluir Pedido
                                                <span class="glyphicon glyphicon-remove" aria-hidden="true">  
                                        
                        
                        
        |]

postExcluirPedidoR :: PedidoId -> Handler Html
postExcluirPedidoR pedidoid = do 
    _ <- runDB $ get404 pedidoid
    runDB $ delete pedidoid
    redirect ListarPedidoR
    

