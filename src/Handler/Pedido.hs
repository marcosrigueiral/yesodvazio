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

-- /pedido                             PedidoR               GET 
-- /pedido/cadastrar                   CadastrarPedidoR      GET POST
-- /pedido/listar                      ListarPedidoR         GET
-- /pedido/buscar/#PedidoId            BuscarPedidoR         GET
-- /pedido/editar/#PedidoId            EditarPedidoR         PUT
-- /pedido/exluir/#PedidoId            ExcluirPedidoR        POST

getPedidoR :: Handler Html
getPedidoR = undefined

getCadastrarPedidoR :: Handler Html
getCadastrarPedidoR = undefined

postCadastrarPedidoR :: Handler Html 
postCadastrarPedidoR = undefined

getListarPedidoR :: Handler Html
getListarPedidoR = undefined

getBuscarPedidoR :: PedidoId -> Handler Html
getBuscarPedidoR = undefined

putEditarPedidoR :: PedidoId -> Handler Html
putEditarPedidoR = undefined

postExcluirPedidoR :: PedidoId -> Handler Html
postExcluirPedidoR = undefined