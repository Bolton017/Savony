<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="stock.*" %>


<%
    try{
        String lien = (String) session.getValue("lien");
        user.UserEJB u= (user.UserEJB) session.getValue("u");

        String idProduit = request.getParameter("idProduit");
        String idMagasin = request.getParameter("idMagasin");

        String titre = "Fiche Inventaire";
        String awhere = "";
        Magasin cat= new Magasin();
        cat.setNomTable("magasinpoint");
        Magasin [] magasins = (Magasin[]) CGenUtil.rechercher(cat,null,null,null,"");

        if (idMagasin==null){
            if (magasins.length>0){
                idMagasin = magasins[0].getId();
            }
        }

        EtatStockParEntree[] etatStocks = new EtatStockParEntree().genererFicheInventaire(idMagasin,idProduit,null);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%=titre%></h1>
    </section>
    <section class="content">
        <div style="width: 100%;display: flex;justify-content: center">
            <form class="col-md-8 col-xs-12" action="<%=lien%>" method="Get" style="padding: 10px;margin: 5px;border-radius: 5px;display: flex;align-items: end;">
                <div class='form-input col-md-4 col-xs-12'>
                    <label class="nopadding fontinter labelinput">Produit</label>
                    <div style="display: flex">
                        <input name="idProduitlibelle" type="text" class="form-control ui-autocomplete-input" id="idProduitlibelle" style="min-width: 50%;" autocomplete="off">
                        <input type="hidden" value="" name="idProduit" id="idProduit">
                        <button type="button" class="btnheight" id="idProduitsearchBtn"><i class="fa fa-search" aria-hidden="true"></i></button>
                    </div>
                </div>
                <div class='form-input col-md-4 col-xs-12'>
                    <label class="nopadding fontinter labelinput">Magasin</label>
                    <select class="form-control" name="idMagasin">
                        <% for (Magasin s:magasins) { %>
                        <%if (idMagasin!=null && s.getId().equals(idMagasin)){%>
                        <option selected value="<%=s.getId()%>"><%=s.getVal()%></option>
                        <%} else {%>
                        <option value="<%=s.getId()%>"><%=s.getVal()%></option>
                        <%}%>
                        <% } %>
                    </select>
                </div>
                <input type='hidden' value='inventaire/fiche-inventaire.jsp' name='but'>
                <div class="form-input col-md-4 col-xs-12">
                    <button class="btn btn-success" style="width: 100%;height: 32px;text-align: center" type="submit">Afficher</button>
                </div>
            </form>
        </div>
        <form id="FormInventaire" action="<%=lien%>?but=apresInventaire.jsp" method="post">
            <input name="idMagasin" type="hidden" value="<%=idMagasin%>">
            <input name="acte" type="hidden" id="nature" value="ficheInventaire">
            <input name="bute" type="hidden" id="bute" value="inventaire/inventaire-fiche.jsp">
            <div class="row">
                <div class="row col-md-12">
                    <div class="box " style="padding: 15px;background-color: white;border-radius: 16px;">
                        <div class="box-body table-responsive no-padding">
                            <div id="selectnonee">
                                <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" class="table table-striped table-hover" style="font-size: 14px;">
                                    <thead>
                                    <tr class="head">
                                        <th align="center" valign="top" style="background-color:#bed1dd">
                                            <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                        </th>
                                        <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                            <a>Produit</a>
                                        </th>
                                        <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                            <a>Magasin</a>
                                        </th>
                                        <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                            <a>Quantiter</a>
                                        </th>
                                        <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                            <a>Prix Unitaire</a>
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% for (int i = 0; i < etatStocks.length; i++) {
                                        EtatStockParEntree r = etatStocks[i];
                                    %>
                                    <tr onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor=''" style="">
                                        <td align="center" width="1%">
                                            <input type="checkbox" value="<%=i%>" name="id" id="checkbox<%=i%>">
                                        </td>
                                        <%--                                        <td width="8%" align="left">--%>
                                        <%--                                            <a href="module.jsp?but=reservation/reservation-details-fiche.jsp&id=<%=r.getId()%>"><%=r.getId()%></a>--%>
                                        <%--                                        </td>--%>
                                        <td width="8%" align="left"><%=r.getIdProduitLib()%></td>
                                        <td width="8%" align="left"><%=(r.getIdMagasinLib() != null) ? r.getIdMagasinLib() : "-"%></td>
                                        <td width="8%" align="left">
                                            <input name="qte_<%=i%>" type="text" class="form-control" id="qte_<%=i%>" value="0" oninput="if(this.value !== '') { cocheChexBox('checkbox<%=i%>') }">
                                        </td>
                                        <td width="8%" align="left">
                                            <input name="pu_<%=i%>" type="text" class="form-control" id="pu_<%=i%>" value="<%=r.getPu()%>" oninput="if(this.value !== '') { cocheChexBox('checkbox<%=i%>') }">
                                        </td>
                                        <input type="hidden" name="produit_<%=i%>" value="<%=r.getId()%>">
                                        <input type="hidden" name="idProduit_<%=i%>" value="<%=r.getIdProduit()%>">
                                        <input type="hidden" name="idProduitLib_<%=i%>" value="<%=r.getIdProduitLib()%>">
                                        <input type="hidden" name="reste_<%=i%>" value="<%=r.getReste()%>">
                                        <input type="hidden" name="magasin_<%=i%>" value="<%=(r.getIdMagasinLib() != null) ? r.getIdMagasinLib() : ""%>">
                                    </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="box-footer">
                            <!-- <button type="button" onclick="exportCSV()" class="btn btn-info pull-right" style="margin-right: 25px;">Export CSV</button> -->
                            <button type="submit" name="method" value="save" class="btn btn-success pull-right" style="margin-right: 25px;">Enregistrer</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xs-12"></div>
        </form>
    </section>
</div>

<script>

    function exportCSV() {
        const form = document.getElementById("FormInventaire");
        const formData = new FormData(form);

        for (let [key, value] of formData.entries()) {
            if (key === "qte_0") {
                console.log(`id sélectionné : ${value}`);
            }
        }

        fetch('http://localhost:8080/savonnerie/ExportCSV?action=exp_inventaire', {
            method: 'POST',
            body: formData
        })
            .then(response => response.text())
            .then(data => {
                // Affiche simplement la réponse du serveur (ex: texte CSV, message, etc.)
                console.log("Réponse du serveur :", data);
                alert("Export terminé !"); // ou injecter dans une div
            })
            .catch(error => {
                console.error('Erreur lors de l\'export :', error);
                alert("Une erreur est survenue.");
            });
    }

    function cocheChexBox(identifiant){
        document.getElementById(identifiant).checked = true;
    }

    jQuery(document).ready(function () {$(function() {
        var autocompleteTriggered = false;
        $("#idProduitlibelle").autocomplete({
            source: function(request, response) {
                $("#idProduit").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(request, response, "null", "id", "null", "ST_INGREDIENTSAUTO", "produits.IngredientsLib", "true","","null");
                }
            },
            select: function(event, ui) {
                $("#idProduitlibelle").val(ui.item.label);
                $("#idProduit").val(ui.item.value);
                $("#idProduit").trigger('change');
                $(this).autocomplete('disable');
                var champsDependant = [''];   for(let i=0;i<champsDependant.length;i++){
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }            autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');
        $("#idProduitlibelle").keydown(function(event) {
            if (event.key === 'Tab') {
                event.preventDefault();
                autocompleteTriggered = true;
                $(this).autocomplete('enable').autocomplete('search', $(this).val());
            }
        });
        $("#idProduitlibelle").on('input', function() {
            $("#idProduit").val('');
            autocompleteTriggered = false;
            $(this).autocomplete('disable');
        });
        $("#idProduitsearchBtn").click(function() {
            autocompleteTriggered = true;
            $("#idProduitlibelle").autocomplete('enable').autocomplete('search', $("#idProduitlibelle").val());
        });
    });$(function() {
        var autocompleteTriggered = false;
        $("#idBclibelle").autocomplete({
            source: function(request, response) {
                $("#idBc").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(request, response, "null", "id", "null", "BONDECOMMANDE_CLIENT", "vente.BonDeCommande", "true","","null");
                }
            },
            select: function(event, ui) {
                $("#idBclibelle").val(ui.item.label);
                $("#idBc").val(ui.item.value);
                $("#idBc").trigger('change');
                $(this).autocomplete('disable');
                var champsDependant = [''];   for(let i=0;i<champsDependant.length;i++){
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }            autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');
        $("#idBclibelle").keydown(function(event) {
            if (event.key === 'Tab') {
                event.preventDefault();
                autocompleteTriggered = true;
                $(this).autocomplete('enable').autocomplete('search', $(this).val());
            }
        });
        $("#idBclibelle").on('input', function() {
            $("#idBc").val('');
            autocompleteTriggered = false;
            $(this).autocomplete('disable');
        });
        $("#idBcsearchBtn").click(function() {
            autocompleteTriggered = true;
            $("#idBclibelle").autocomplete('enable').autocomplete('search', $("#idBclibelle").val());
        });
    });}); </script>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>

