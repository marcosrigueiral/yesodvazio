{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Entrada where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /entrada                            EntradaR              GET
-- /entrada/cadastrar                  CadastrarEntradaR     GET POST
-- /entrada/listar                     ListarEntradaR        GET
-- /entrada/buscar/#EntradaId          BuscarEntradaR        GET
-- /entrada/editar/#EntradaId          EditarEntradaR        PUT
-- /entrada/exluir/#EntradaId          ExcluirEntradaR       POST

-- Entrada json
--    dataentrada     Day
--    prodid          ProdutoId
--    descricao       Text
--    fornecid        FornecedorId
--    quant           Int
--    custopadrao     Double
--    valortotal      Double
--    deriving Show

-- formulário de Lançamento de Entradas
formEntrada :: Form Entrada
formEntrada = renderDivs $ Entrada
    <$> areq dayField FieldSettings{fsId=Just "txtDataEntrada",
                                      fsLabel="Data Entrada: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] EntradaDescricao) FieldSettings{fsId=Just "txtEntradaId",
                                      fsLabel="Descrição: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] fornecedorNome) FieldSettings{fsId=Just "txtFornecedor",
                                      fsLabel="Fornecedor: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq doubleField FieldSettings{fsId=Just "txtQuantidade",
                                      fsLabel="Quantidade: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq doubleField FieldSettings{fsId=Just "txtCusto",
                                      fsLabel="Custo: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq doubleField FieldSettings{fsId=Just "txtCusto",
                                      fsLabel="Valor total: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing

getEntradaR :: Handler Html
getEntradaR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
        |]
        [whamlet|
            <h1> Entradas
            <ul>
                <li> <a href=@{CadastrarEntradaR}>  Cadastrar Entradas
                <li> <a href=@{ListarEntradaR}>  Listar Entradas
                <li> <a href=@{HomeR}>  Home
        |]
        
-- preenchimento de formulario para cadastro de Entradas utilizando o form criado acima
getCadastrarEntradaR :: Handler Html
getCadastrarEntradaR = do
    (widget,enctype) <- generateFormPost formEntrada
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
                        <a class="navbar-brand" href="#">
                            <img src="../../static/img/logo-2.png" class="logo-menu" />
                    <div id="navbar" class="collapse navbar-collapse">
                        <ul class="nav navbar-nav">
                            <li class="dropdown">
                                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                    Entradas
                                    <span class="caret">
                                <ul class="dropdown-menu">
                                    <li>
                                        <a href=@{CadastrarEntradaR}>
                                            Cadastro de Entradas
                                    <li>
                                        <a href=@{ListarEntradaR}>
                                            Listagem de Entradas
            <div class="container">   
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <span class="glyphicon glyphicon-download-alt" aria-hidden="true">
                        Cadastro de Entradas        
                    <div class="panel-body">
                        <form action=@{CadastrarEntradaR} method=post>
                            ^{widget}
                            <div class="btn-area">
                                <button type="submit" value="" class="btn btn-success btn-enviar">
                                    Cadastrar
                                    <span class="glyphicon glyphicon-plus" aria-hidden="true">                        
        |]

postCadastrarEntradaR :: Handler Html 
postCadastrarEntradaR = do
    ((res,_),_) <- runFormPost formEntrada
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect EntradaR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarEntradaR

