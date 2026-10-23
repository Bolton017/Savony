
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.ressources.InfosAuto" %>
<%@ page import="java.util.LinkedHashMap" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%try{
    InfosAuto d = new InfosAuto();
    d.setNomTable("INFOSAUTOLIB");
    PageConsulte pc = new PageConsulte(d, request, u);
    pc.setTitre("Fiche du v&eacute;hicule");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    InfosAuto auto=(InfosAuto)pc.getBase();

    pc.getChampByName("idIngredient").setVisible(false);

    String lien = (String) session.getValue("lien");
    String pageModif = "maintenance/ressources/auto/auto-saisie.jsp";
    String pageDep = "facturefournisseur/facturefournisseur-saisie.jsp";
    String classe = "maintenance.ressources.InfosAuto";

    pc.getChampByName("numeroDeParc").setLibelle("Numéro de parc");
    pc.getChampByName("datePremiereMiseEnCirculation").setLibelle("Date de première mise en circulation");
    pc.getChampByName("numero").setLibelle("Numéro");
    pc.getChampByName("annee").setLibelle("Année");
    pc.getChampByName("nombreDePortes").setLibelle("Nombre de portes");
    pc.getChampByName("idIngredientLib").setLibelle("Type");
    pc.getChampByName("puissanceFiscale").setLibelle("Puissance fiscale");
    pc.getChampByName("valeurInitiale").setLibelle("Valeur initiale");
    pc.getChampByName("datedebut").setLibelle("Date de début");
    pc.getChampByName("nombreDePlaces").setLibelle("Nombre de places");
    pc.getChampByName("huileMoteur").setLibelle("Huile moteur");
    pc.getChampByName("typeDeCarburantLib").setLibelle("Type de carburant");
    pc.getChampByName("uniteDeConsommationLib").setLibelle("Unité de consommation");
    pc.getChampByName("modele").setLibelle("Mod&egrave;le");
    pc.getChampByName("mensualite").setLibelle("Mensualit&eacute;");

    pc.getChampByName("typeDeCarburant").setVisible(false);
    pc.getChampByName("idIngredientLib").setVisible(false);
    pc.getChampByName("uniteDeConsommation").setVisible(false);

    LinkedHashMap<String,String[]> rubriques = new LinkedHashMap<String,String[]>();
    rubriques.put("Identifiant", new String[]{"id","idIngredientLib","description","numeroDeParc","immatriculation","datePremiereMiseEnCirculation","note"});
    rubriques.put("Carte carburant", new String[]{"fournisseur","numero","volume","montant","typeCarburantLib","consommation"});
    rubriques.put("Modèle", new String[]{"vin","marque","modele","annee","nombreDePortes","nombreDePlaces","puissanceFiscale","type"});
    rubriques.put("Location longue durrée", new String[]{"bailleur","valeurInitiale","datedebut","dureeEnMois"});
    rubriques.put("Achat", new String[]{"vendeur","prix","dateAchat","mensualite"});
    rubriques.put("Références", new String[]{"pneus","batterie","huileMoteur"});
    rubriques.put("Carburant", new String[]{"typeDeCarburantLib","uniteDeConsommationLib"});
    String pageActuel = "maintenance/ressources/auto/auto-fiche.jsp";
    pc.setRubrique(rubriques);
    Map<String, String> map = new HashMap<>();
    map.put("inc/travaux-details", "");
    map.put("inc/achat-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/travaux-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maintenance/ressources/auto/auto-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
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
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id +"&acte=update"%>">Modifier</a>
<%--                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=" + pageTravaux + "&idMachine=" + id+"&entite="+d.getIdEntite()%>" style="margin-right:10px;">Demande de travaux</a>--%>

                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageDep +"&idElementMaintenance=" + auto.getIdIngredient() +"&acte=insert"%>">Saisir D&eacute;pense</a>

<%--                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maintenance/ressources/personnel/departement-liste.jsp&classe="+classe %>">Supprimer</a>--%>
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
                    <li class="<%=map.get("inc/travaux-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/travaux-details">Travaux</a></li>
                    <li class="<%=map.get("inc/achat-details.jsp")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/achat-details">Depense</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
</div>
<%
    }catch(Exception e){
    e.printStackTrace();
    }
%>

