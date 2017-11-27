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

getProdutoR :: Handler Html
getProdutoR = error "undefined"

getCadastrarProdutoR :: Handler Html
getCadastrarProdutoR = error "undefined"

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