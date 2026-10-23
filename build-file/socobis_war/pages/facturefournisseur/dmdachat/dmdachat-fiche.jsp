<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="faturefournisseur.DmdAchatLib" %>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@page import="utils.*"%>
<%@ page import="budget.UtilisateurService" %>
<%@ page import="faturefournisseur.service.Service" %>

<%
    try{
         UserEJB u = (user.UserEJB)session.getValue("u"); 
        String lien = (String) session.getValue("lien");
        DmdAchatLib t = new DmdAchatLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (DmdAchatLib) pc.getBase();

        String dossier = "DmdAchatLib";

        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("daty").setLibelle("Date de la demande d'achat");
        pc.getChampByName("remarque").setLibelle("remarque");
        pc.getChampByName("fournisseurLib").setLibelle("Fournisseur");
        pc.getChampByName("fournisseurLib").setLien((String) session.getValue("lien") + "?but=fournisseur/fournisseur-fiche.jsp&id=" + t.getFournisseur(), "nom=");
        pc.getChampByName("fournisseur").setVisible(false);
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("dateLimite").setLibelle("Date limite de livraison");
        pc.getChampByName("idMagasinLib").setLibelle("Magasin");
        pc.getChampByName("idCategorieLib").setLibelle("Cat&eacute;gorie");
        pc.getChampByName("idObjet").setLibelle("Origine");
        pc.getChampByName("serviceLib").setLibelle("D&eacute;partement du demandeur");
        pc.getChampByName("idObjet").setVisible(false);
        pc.getChampByName("idPrioriteLib").setLibelle("Priorit&eacute;");
        pc.getChampByName("destinataireLib").setLibelle("D&eacute;partement cible");
        pc.getChampByName("service").setVisible(false);
        pc.getChampByName("destinataire").setVisible(false);
        pc.getChampByName("idPriorite").setVisible(false);

        pc.setTitre("Fiche de demande d'achat");
        String pageModif = "facturefournisseur/dmdachat/dmdachat-saisie.jsp";
        String pageActuel = "facturefournisseur/dmdachat/dmdachat-fiche.jsp";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/dmdachat-details", "");
        map.put("inc/bondecommande-liste", "");
        map.put("inc/commentaire-liste", "");

        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/dmdachat-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        DmdAchatLib da=(DmdAchatLib)pc.getBase();
        boolean avecBC = da.avecBC(null);
        boolean estAvecProformaDetailsValide;
        String lienBC = lien + "?but=bondecommande/bondecommande-saisie.jsp&iddmdachat=" + id;
        if (!avecBC) {
            estAvecProformaDetailsValide = da.estAvecProformaDetailsValide(null);
            if (estAvecProformaDetailsValide) {
                lienBC = lien + "?but=facturefournisseur/dmdachat/inc/apresGenererBcProforma.jsp&iddmdachat=" + id;
            }
        }
        int etat = t.getEtat();
        String role = u.getUser().getIdrole();
        UtilisateurService us = new UtilisateurService();
        us.setRefuser(u.getUser().getTuppleID());
        us = us.getUserService(null);

        boolean afficher = false;
        boolean initiateur = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_ACHAPPROV);
        boolean chefdep = role.equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEF_DEP);
        Service[] services = new Service().servicesImpliques(t.getService(), t.getDestinataire());
        boolean directionSource = us.getIdDepartement() != null && us.getIdDepartement().equalsIgnoreCase(services[0].getDepartement());
        boolean directionCible = us.getIdDepartement() != null && us.getIdDepartement().equalsIgnoreCase(services[1].getDepartement());
        if (initiateur && etat <= ConstanteEtat.getEtatCreer()){
            afficher = true;
        }
        if(chefdep && etat <= ConstanteSavonnerie.VALIDERACHAPPROV) {
            afficher = true;
        }
        if (directionSource && etat <= ConstanteSavonnerie.VALIDERCHEFDEP){
            afficher = true;
        }
        if (us.getIdService().equalsIgnoreCase(t.getDestinataire()) && chefdep && etat == ConstanteSavonnerie.VALIDERDIRSOURCE){
            afficher = true;
        }
        if (directionCible && etat == ConstanteSavonnerie.VALIDERCHEFDEPCIBLE){
            afficher = true;
        }
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=facturefournisseur/dmdachat/dmdachat-liste.jsp"%> ><i class="fa fa-angle-left"></i></a><% out.println(pc.getTitre()); %></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <% if (afficher) { %>
                                <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=facturefournisseur/dmdachat/dmdachat-fiche.jsp&classe=faturefournisseur.DmdAchat&nomtable=DMDACHAT"%> " style="margin-right: 10px">Valider</a>
                            <% } if (da.getEtat() < 3 ) {%>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&acte=annuler&id=" + id + "&bute=facturefournisseur/dmdachat/dmdachat-fiche.jsp&classe=faturefournisseur.DmdAchat"%>" style="margin-right: 10px">Annuler</a>
                            <% } %>
                            <% if(da.getEtat()<11){ %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/proforma/proforma-saisie.jsp&iddmdachat=" + id %> " style="margin-right: 10px">Insertion Proforma</a>
                            <% } %>
                            <% if(da.getEtat()>=11 && !avecBC){ %>
                                <a class="btn btn-secondary pull-right" href="<%= lienBC %> " style="margin-right: 10px">G&eacute;n&eacute;rer Bon de commande</a>
                        <%--                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/facturefournisseur-saisie.jsp&iddmdachat=" + id %> " style="margin-right: 10px">Insertion Facture Fournisseur</a>--%>
                            <% } %>

                            <% if(da.getEtat() <= 3){ %>
<%--                                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/apres-valider-proformas.jsp&iddmdachat=" + id+"&bute="+pageActuel %> " style="margin-right: 10px">Envoi proposition</a>--%>
                            <% } %>
                            <% if(da.getEtat() > 3){ %>
                                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/apres-valider-proformas.jsp&iddmdachat=" + id+"&bute="+pageActuel %> " style="margin-right: 10px">Valider achat</a>
                            <% } %>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=facturefournisseur/dmdachat/commentaire-demande-saisie.jsp&id=" + id +"&bute="+pageActuel%> " style="margin-right: 10px">Ajouter commentaire</a>

                            <a class="btn btn-tertiary pull-right"
                               href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + id + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + id %>"
                               style="margin-right:10px;">Attacher Fichier</a>

                            <a class="btn btn-tertiary pull-right"
                               href="<%= lien + "?but=facturefournisseur/dmdachat/apres-retour.jsp&iddmdachat=" + id+"&bute="+pageActuel %>"
                               style="margin-right:10px;">Retour</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row m-0">
        <div class="col-md-12 nopadding">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("inc/dmdachat-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/dmdachat-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/proforma-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/proforma-liste">Proforma</a></li>
                    <li class="<%=map.get("inc/comparaison-prix")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/comparaison-prix">Comparaison de prix</a></li>
                    <li class="<%=map.get("inc/proposition-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/proposition-details">Situation en stock</a></li>
<%--                    <li class="<%=map.get("inc/proforma-liste-valide")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/proforma-liste-valide">Proforma valid&eacute;s</a></li>--%>
                    <li class="<%=map.get("inc/commentaire-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/commentaire-liste">Commentaire</a></li>
                    <li class="<%=map.get("inc/historique-validation")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historique-validation">Historique de Validation</a></li>
                    <li class="<%=map.get("inc/bondecommande-liste")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-liste">Bon de commande</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

    <% out.println(pc.getHtmlAttacherFichier());%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>