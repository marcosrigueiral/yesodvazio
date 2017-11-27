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
getFornecedorR = error "undefined"

getCadastrarFornecedorR :: Handler Html
getCadastrarFornecedorR = error "undefined"

postCadastrarFornecedorR :: Handler Html 
postCadastrarFornecedorR = error "undefined"

getListarFornecedorR :: Handler Html
getListarFornecedorR = error "undefined"

getBuscarFornecedorR :: FornecedorId -> Handler Html
getBuscarFornecedorR = error "undefined"

putEditarFornecedorR :: FornecedorId -> Handler Html
putEditarFornecedorR = error "undefined"

postExcluirFornecedorR :: FornecedorId -> Handler Html
postExcluirFornecedorR = error "undefined"