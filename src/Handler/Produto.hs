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

-- formulário de cadastro de Usuarios
formProduto :: Form Produto
formProduto = renderDivs $ Produto
    <$> areq textField     "Nome: "         Nothing
    <*> areq textField     "Descricao: "    Nothing
    <*> areq textField     "Código: "       Nothing
    <*> areq (selectField $ optionsPersistKey [] [] categoriaDescricao) "Categoria: " Nothing
    <*> areq doubleField   "Custo: "        Nothing
    <*> areq doubleField   "Preço: "        Nothing
    <*> areq intField      "Estoque: "      Nothing
    <*> areq dayField      "Data Cadastro: " Nothing
    <*> areq (selectField $ optionsPersistKey [] [] fornecedorNome) "Fornecedor: " Nothing
 -- <*> (fmap toSqlKey $ areq intField "Tipo Usuario" Nothing)

getProdutoR :: Handler Html
getProdutoR = error "undefined"

-- preenchimento de formulario para cadastro de Produtos utilizando o form criado acima
getCadastrarProdutoR :: Handler Html
getCadastrarProdutoR = do 
    (widget,enctype) <- generateFormPost formProduto
    defaultLayout $ do
        [whamlet|
            <form action=@{CadastrarProdutoR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postCadastrarProdutoR :: Handler Html 
postCadastrarProdutoR = error "undefined"

getListarProdutoR :: Handler Html
getListarProdutoR = do 
    produtos <- runDB $ selectList [] [Asc ProdutoNome]
    defaultLayout $ do 
        [whamlet|
            <table>
                <thead>
                    <tr>
                        <td> 
                            Nome
                        <td>
                            Precolista
                        <td>
                            Estoque
                        <td>
                            
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
                                    <input type="submit" value="Apagar">
                        
                        
        |]
        

getBuscarProdutoR :: ProdutoId -> Handler Html
getBuscarProdutoR = error "undefined"

putEditarProdutoR :: ProdutoId -> Handler Html
putEditarProdutoR = error "undefined"

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