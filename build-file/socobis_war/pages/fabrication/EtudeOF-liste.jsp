<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 2025-04-01
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="fabrication.Of" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="affichage.Liste" %>
<%@ page import="fabrication.EtudeOf" %>

<% try{
    EtudeOf t = new EtudeOf();
    t.setNomTable("EtudeOFLIB");
    String listeCrt[] = {"id", "lancepar", "cible", "remarque", "libelle", "besoin", "daty","etat"};
    String listeInt[] = {"daty","besoin"};
    String libEntete[] = {"id", "libelle", "daty", "besoin", "cible", "remarque","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des ordres de fabrication");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/EtudeOF-liste.jsp");
    Liste [] listes = new Liste[1];
    String [] val = new String[]{"%","1","11","0","21","31","41"};
    String [] aff = new String[]{"Tous","Cr&eacute;e","Valid&eacute;e","Annul&eacute;e","Entam&eacute;","Bloqu&eacute;","Termin&eacute;e"};
    listes[0] = new Liste("etat",aff,val);
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("besoin1").setLibelle("Date de Besoin min");
    pr.getFormu().getChamp("besoin2").setLibelle("Date de Besoin max");
    pr.getFormu().getChamp("lancepar").setLibelle("Lanc&eacute; par");
    pr.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    String[] colSomme = null;
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.getDebutSemaineString());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.getFinSemaineString());
//    pr.getFormu().getChamp("besoin1").setDefaut(Utilitaire.getDebutSemaineString());
//    pr.getFormu().getChamp("besoin2").setDefaut(Utilitaire.getFinSemaineString());

    if(request.getParameter("id")!=null && request.getParameter("id").compareToIgnoreCase("")!=0) {
        pr.getFormu().getChamp("id").setDefaut(request.getParameter("id"));
    }
    if(request.getParameter("etaty")!=null && request.getParameter("etaty").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat>=" + request.getParameter("etaty"));
    }

    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=fabrication/EtudeOF-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fabrication/EtudeOF-fiche.jsp"};
    String colonneLien[] = {"id"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID","D&eacute;signation", "Date","Date de besoin", "Cible", "Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("fabrication/inc/EtudeOf-details.jsp&id=");
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=fabrication/EtudeOF-saisie.jsp&currentMenu=MENUDYN3204004\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un ordre de fabrication</a>"
    );
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



