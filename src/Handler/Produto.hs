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
getProdutoR = undefined

getCadastrarProdutoR :: Handler Html
getCadastrarProdutoR = undefined

postCadastrarProdutoR :: Handler Html 
postCadastrarProdutoR = undefined

getListarProdutoR :: Handler Html
getListarProdutoR = undefined

getBuscarProdutoR :: ProdutoId -> Handler Html
getBuscarProdutoR = undefined

putEditarProdutoR :: ProdutoId -> Handler Html
putEditarProdutoR = undefined

postExcluirProdutoR :: ProdutoId -> Handler Html
postExcluirProdutoR = undefined