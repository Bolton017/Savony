<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="utilitaire.*" %>
<%@page import="faturefournisseur.*"%>
<%@ page import="affichage.*" %>
<%@ page import="affichage.Champ" %>
<%@ page import="caisse.EtatCaisse" %>
<%@ page import="prevision.Prevision" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="vente.VenteLib" %>
<%@ page import="prevision.PrevisionComplet" %>
<%
    try{
        FactureFournisseurCpl ff = null;
        VenteLib vente = null;
        ClassMAPTable[] vls = null;
        String classeButApresPost = null;

        System.out.println("classe: " + request.getParameter("classe"));
        if(request.getParameter("classe")!=null){
            classeButApresPost = request.getParameter("classe");
            if(request.getParameter("classe").equals("faturefournisseur.FactureFournisseur")){
                ff = new FactureFournisseurCpl();
                ff.setNomTable(request.getParameter("table"));
                ff.setId(request.getParameter("idvt"));
                vls=(FactureFournisseurCpl[]) CGenUtil.rechercher(ff, null, null, "");
            }
            if(request.getParameter("classe").equals("vente.Vente")){
                vente = new VenteLib();
                vente.setNomTable(request.getParameter("table"));
                vente.setId(request.getParameter("idvt"));
                vls = (VenteLib[]) CGenUtil.rechercher(vente, null, null, "");

            }
        }
        if (request.getParameter("classe")==null ||request.getParameter("classe").equals("null") || request.getParameter("classe").equals("prevision.PrevisionComplet") ) {
            PrevisionComplet prev = new PrevisionComplet();
            prev.setIdFactureMere(request.getParameter("idvt")); ;
            vls=(PrevisionComplet[]) CGenUtil.rechercher(prev, null, null, "");
        }


        PrevisionComplet prev = new PrevisionComplet();
        prev.setIdFactureMere(request.getParameter("idvt"));
        prev.setNomTable("PREVISION_COMPLET_CPLPOSITIF");
        PrevisionComplet[] listePrev = (PrevisionComplet[]) CGenUtil.rechercher(prev, null, null, "");
        Prevision a = new Prevision();
        PageInsert pi = new PageInsert(prev, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        // liste deroulante
        Liste[] liste = new Liste[1];
        Caisse caisse = new Caisse();
        liste[0] = new Liste("idCaisse", caisse, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        //Modification des affichages
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");

        String idclient="";
        String designation="";
        String devise="";
        String tauxdechange="";
        String obj="";
        if(vls[0] instanceof FactureFournisseurCpl) {
            ff = (FactureFournisseurCpl)vls[0];
            designation = ff.getDesignation();
            devise = ff.getIdDevise();
            tauxdechange=String.valueOf(ff.getTauxdechange());
            obj="FactureFournisseur";

        }
        else if(vls[0] instanceof VenteLib) {
            vente = (VenteLib)vls[0];
            designation = vente.getDesignation();
            idclient = vente.getIdClient();
            devise = vente.getIdDevise();
            tauxdechange=String.valueOf(vente.getTauxdechange());
            obj="Vente";
        }
        else if(vls[0] instanceof PrevisionComplet) {
            prev = (PrevisionComplet)vls[0];
            designation = prev.getDesignation();
            devise = prev.getIdDevise();
            // tauxdechange=String.valueOf(prev.getTauxdechange());
            obj="PrevisionComplet";
        }
        pi.getFormu().getChamp("designation").setDefaut("Plan de paiement de "+designation);
        pi.getFormu().getChamp("idcaisse").setLibelle("Caisse");
        pi.getFormu().getChamp("idcaisse").setVisible(false);
        pi.getFormu().getChamp("idventedetail").setVisible(false);
        pi.getFormu().getChamp("idvirement").setVisible(false);
        pi.getFormu().getChamp("debit").setLibelle("D&eacute;bit");
        pi.getFormu().getChamp("credit").setLibelle("Cr&eacute;dit");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idop").setVisible(false);
        pi.getFormu().getChamp("idorigine").setVisible(false);
        pi.getFormu().getChamp("iddevise").setLibelle("Devise");
        pi.getFormu().getChamp("iddevise").setDefaut(devise);
        pi.getFormu().getChamp("taux").setLibelle("Taux de change");
        pi.getFormu().getChamp("taux").setDefaut(tauxdechange);
        pi.getFormu().getChamp("idtiers").setLibelle("Client");
        if (!idclient.equalsIgnoreCase(""))
        {
            pi.getFormu().getChamp("idtiers").setDefaut(idclient);
            pi.getFormu().getChamp("idtiers").setAutre("readonly");
        }
        else pi.getFormu().getChamp("idtiers").setPageAppelCompleteInsert("client.Client", "id", "CLIENT", "client/client-saisie.jsp", "id;nom");

        pi.getFormu().getChamp("compte").setVisible(false);
        //pi.getFormu().getChamp("idFactureMere").setLibelle("Facture");
        if (request.getParameter("idvt") != null && !request.getParameter("idvt").equalsIgnoreCase(""))
        {
            pi.getFormu().getChamp("idFactureMere").setLibelle("Facture");
            pi.getFormu().getChamp("idFactureMere").setDefaut(request.getParameter("idvt"));
            pi.getFormu().getChamp("idFactureMere").setAutre("readonly");
        }
        //Variables de navigation
        String classe = "prevision.PrevisionComplet";
        String butApresPost = "vente/planPaiement-saisie.jsp&idvt="+request.getParameter("idvt")+"&classe="+classeButApresPost;
        String nomTable = "PREVISION";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<style>
    .table-container.nopadding.borderless {
        padding-right: 0 !important;
    }

</style>
<div class="content-wrapper">
    <h1 align="center">Plan de Paiement</h1>
    <form  action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%--
           out.println(pi.getFormu().getHtmlInsert());
       --%>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
    <form id="incident" class="incident-pp-fiche" onsubmit='modifEtatMult(event)' enctype="multipart/form-data">

        <!-- Début du Container basé sur le Template -->
        <div style="background: white;padding: 8px;" class="col-md-12 cardradius box-body table-responsive">

            <input type="hidden" name="bute" value="vente/planPaiement-saisie.jsp&idvt=<%=request.getParameter("idvt")%>&classe=<%=classeButApresPost%>"/>
            <input type="hidden" name="acte" id="acte"/>

            <div class="table-container nopadding borderless">
                <table class="table table-bordered table-modif-pp" style="margin-top: 8px;">
                    <thead>
                    <tr>
                        <th class="contenuetable " style=" text-align: center" colspan="1">
                            <input onclick="CocheToutCheckbox(this, 'ids')" type="checkbox">
                        </th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">D&eacute;signation</label></th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">D&eacute;bit</label></th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">Cr&eacute;dit</label></th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">Date</label></th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">Devise</label></th>
                        <th class="contenuetable " style="color:white;" colspan="1"><label multi-lang="">Taux</label></th>
                    </tr>
                    </thead>

                    <tbody>
                    <%
                        for (int i = 0; i < listePrev.length; i++) {
                    %>
                    <!-- J'ai conservé ton JS Inline mais je te conseille vivement de passer par du CSS -->
                    <tr id="ligne-multiple-<%=i%>" onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                        <td style="text-align: center;vertical-align: middle;" align="center">
                            <input type="checkbox" value="<%=listePrev[i].getId()%>_<%=i%>" name="ids" id="<%=listePrev[i].getId()%>_<%=i%>">
                        </td>

                        <td><%=listePrev[i].getDesignation()%></td>
                        <td><input class="form-control montant-plan-paiement" type="text" id="debit<%=i%>" name="debit" value="<%=listePrev[i].getDebit()%>" onchange="synchroMontantPlanPaiement(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                        <td><input class="form-control montant-plan-paiement" type="text" id="credit<%=i%>" name="credit" value="<%=listePrev[i].getCredit()%>" onchange="synchroMontantPlanPaiement(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                        <td><input class="form-control" type="date" id="daty<%=i%>" name="daty" value="<%=listePrev[i].getDaty()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                        <td><%=listePrev[i].getIdDevise()%></td>
                        <td><input class="form-control" type="text" id="taux<%=i%>" name="taux" value="<%=listePrev[i].getTaux()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                    </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <!-- Footer des boutons (Adapté du template) -->
            <div class="box-footer borderless nopadding pp-fiche-btn">
                <%
                    if(obj.equalsIgnoreCase("FactureFournisseur"))
                    {%>
                <a class="btn btn-primary pull-right " href="<%=pi.getLien()%>?but=facturefournisseur/facturefournisseur-fiche.jsp&tab=inc/liste-prevision&id=<%=request.getParameter("idvt")%>">Voir facture</a>
                <%
                    } if(obj.equalsIgnoreCase("Vente"))
                {%>
                <a class="btn btn-primary pull-right " href="<%=pi.getLien()%>?but=vente/vente-fiche.jsp&tab=liste-prevision&id=<%=request.getParameter("idvt")%>">Voir vente</a>
                <%
                    }
                %>
                <button type="submit" name="acte" value="supprimer_prevision" class="btn btn-danger  pull-left" style="margin-right: 8px;" onclick="document.getElementById('acte').value='supprimer_prevision'" multi-lang="">Supprimer</button>
                <button type="submit" name="acte" value="modifier_prevision" class="btn btn-secondary  pull-right" style="margin-right: 8px;" onclick="document.getElementById('acte').value='modifier_prevision'" multi-lang="">Modifier</button>
                <button type="submit" name="acte" value="modifier_prevision" class="btn btn-secondary  pull-right" style="margin-right: 8px;" onclick="document.getElementById('acte').value='scinder_prevision'" multi-lang="">Scinder</button>
            </div>

        </div>
    </form>
</div>
<script>
    function synchroMontantPlanPaiement(champ, champCheck) {
        champ.value = champ.value.replace(/\s/g, '');
        synchro(champ, champCheck);
        champ.value = formatNumber(champ.value.replace(',', '.'));
    }

    function formatNumber(number) {
        if (number === null || number === undefined) return '';
        number = String(number).replace(/\s/g, '').replace(',', '.');
        if (number === '' || isNaN(number)) return '';
        return Number(number).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }

    document.querySelectorAll('.montant-plan-paiement').forEach(function (champ) {
        champ.value = formatNumber(champ.value);
        champ.addEventListener('focus', function () {
            this.value = this.value.replace(/\s/g, '');
        });
        champ.addEventListener('blur', function () {
            this.value = formatNumber(this.value);
        });
    });
</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
