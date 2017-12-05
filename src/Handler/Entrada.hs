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

--    <*> areq (selectField $ optionsPersistKey [] [] fornecedorNome) FieldSettings{fsId=Just "txtFornecedor",
--                                      fsLabel="Fornecedor: ",
--                                      fsTooltip= Nothing,
--                                      fsName= Nothing,
--                                      fsAttrs=[("class","form-control")]} Nothing

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
    <*> areq intField FieldSettings{fsId=Just "txtQuantidade",
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
