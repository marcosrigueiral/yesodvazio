{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Fornecedor where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- /fornecedor                         FornecedorR           GET
-- /fornecedor/cadastrar               CadastrarFornecedorR  GET POST
-- /fornecedor/listar                  ListarFornecedorR     GET
-- /fornecedor/buscar/#FornecedorId    BuscarFornecedorR     GET
-- /fornecedor/editar/#FornecedorId    EditarFornecedorR     PUT
-- /fornecedor/excluir/#FornecedorId   ExcluirFornecedorR    POST

getFornecedorR :: Handler Html
getFornecedorR = undefined

getCadastrarFornecedorR :: Handler Html
getCadastrarFornecedorR = undefined

postCadastrarFornecedorR :: Handler Html 
postCadastrarFornecedorR = undefined

getListarFornecedorR :: Handler Html
getListarFornecedorR = undefined

getBuscarFornecedorR :: FornecedorId -> Handler Html
getBuscarFornecedorR = undefined

putEditarFornecedorR :: FornecedorId -> Handler Html
putEditarFornecedorR = undefined

postExcluirFornecedorR :: FornecedorId -> Handler Html
postExcluirFornecedorR = undefined