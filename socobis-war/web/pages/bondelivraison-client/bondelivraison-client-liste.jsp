<%-- 
    Document   : bondelivraison-client-liste
    Created on : 30 juil. 2024, 21:36:16
    Author     : bruel
--%>

<%@page import="vente.As_BondeLivraisonClient_Cpl"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="magasin.Magasin"%>
<%@page import="affichage.Liste"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>
<% try{ 
    As_BondeLivraisonClient_Cpl bdlc = new As_BondeLivraisonClient_Cpl();
    String nomTable = "AS_BONDELIVRAISONCLIENT_LIBCPL";
        if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("etat");
        }

       bdlc.setNomTable(nomTable);
    String listeCrt[] = {"id","daty","idmagasinlib","idclientlib","remarque"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","idclientlib","idmagasinlib","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(bdlc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de livraison client");
     
    // Changer en Liste
    // Initialisation Liste

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondelivraison-client/bondelivraison-client-liste.jsp");
   
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
    String classe = "vente.As_BondeLivraisonClient";
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=bondelivraison-client/bondelivraison-client-liste.jsp&classe=" + classe+"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);



    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondelivraison-client/bondelivraison-client-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("bondelivraison-client/inc/bondelivraisonclient-liste-detail.jsp&id=");
    String libEnteteAffiche[] = {"Ref.","Date","Client","Magasin","Remarque","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"AS_BONDELIVRAISONCLIENT_LIBCPL","AS_BONDELIVRAISONC_LIBCPL_c", "AS_BONDELIVRAISONC_LIBCPL_v", "AS_BONDELIVRAISONC_LIBCPL_a"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)","Valid&eacute;(s)","Annul&eacute;(s)"};
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=bondelivraison-client/bondelivraison-client-saisie.jsp&currentMenu=MNDN0000000121\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un bon de livraison</a>"
    );
%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdlc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding  ">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
        %>
    </section>
    
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
