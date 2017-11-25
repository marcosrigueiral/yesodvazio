{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Cliente where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /cliente                            clienteR            GET       
-- /cliente/cadastrar                  CadastrarClienteR   GET POST
-- /cliente/listar                     ListarClienteR       GET
-- /cliente/buscar/#ClienteId          BuscarClienteR      GET
-- /cliente/editar/#ClienteId          EditarClienteR      PUT
-- /cliente/excluir/#ClienteId         ExcluirClienteR     POST

getClienteR :: Handler Html
getClienteR = undefined

getCadastrarClienteR :: Handler Html
getCadastrarClienteR = undefined

postCadastrarClienteR :: Handler Html
postCadastrarClienteR = undefined

getListarClienteR :: Handler Html
getListarClienteR = undefined

getBuscarClienteR :: ClienteId -> Handler Html
getBuscarClienteR = undefined

putEditarClienteR :: ClienteId -> Handler Html
putEditarClienteR = undefined

postExcluirClienteR :: ClienteId -> Handler Html
postExcluirClienteR = undefined