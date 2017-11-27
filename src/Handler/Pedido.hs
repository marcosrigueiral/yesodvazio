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
getPedidoR = error "undefined"

getCadastrarPedidoR :: Handler Html
getCadastrarPedidoR = error "undefined"

postCadastrarPedidoR :: Handler Html 
postCadastrarPedidoR = error "undefined"

getListarPedidoR :: Handler Html
getListarPedidoR = error "undefined"

getBuscarPedidoR :: PedidoId -> Handler Html
getBuscarPedidoR = error "undefined"

putEditarPedidoR :: PedidoId -> Handler Html
putEditarPedidoR = error "undefined"

postExcluirPedidoR :: PedidoId -> Handler Html
postExcluirPedidoR = error "undefined"