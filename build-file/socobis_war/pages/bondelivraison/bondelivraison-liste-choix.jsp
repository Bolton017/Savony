<%@page import="vente.As_BondeLivraisonClient_Cpl"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<% try{
    As_BondeLivraisonClient_Cpl bdlc = new As_BondeLivraisonClient_Cpl();
    String nomTable = "AS_BONDELIVRAISONCLIENT_LIBCPL";
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        nomTable = request.getParameter("etat");
    }

    bdlc.setNomTable(nomTable);
    String listeCrt[] = {"id","daty","remarque","idmagasinlib","idclientlib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","idclientlib","idmagasinlib","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(bdlc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de livraison client");

    // Changer en Liste
    // Initialisation Liste

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondelivraison/bondelivraison-liste-choix.jsp");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idMagasinLib",new magasin.Magasin(),"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("idmagasinlib").setLibelle("Magasin");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    //  pr.getFormu().getChamp("daty").setLibelle("daty");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);


    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setLienFille("bondelivraison/inc/bondelivraison-details.jsp&id=");
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("bondelivraison-client/inc/bondelivraisonclient-liste-detail.jsp&id=");
    String libEnteteAffiche[] = {"R&eacute;f&eacute;rence","Date","Client","Magasin","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"AS_BONDELIVRAISONCLIENT_LIBCPL","AS_BONDELIVRAISONC_LIBCPL_c", "AS_BONDELIVRAISONC_LIBCPL_v", "AS_BONDELIVRAISONC_LIBCPL_a"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=bondelivraison-client/bondelivraison-client-saisie.jsp&currentMenu=MNDN0000000121\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de livraison</a>"
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
        <form action="<%= pr.getLien()+"?but=transport/course-saisie.jsp"%>" method="post">
            <input type="hidden" value="transport/course-fiche.jsp" name="bute" id="bute">
            <input type="hidden" value="true" name="livraison" id="livraison">
            <%
                pr.getTableau().setNameBoutton("Valider");
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
