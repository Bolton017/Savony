<%@page import="faturefournisseur.As_BonDeLivraison_Lib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% 
    try{ 
    As_BonDeLivraison_Lib t = new As_BonDeLivraison_Lib();
    t.setNomTable("As_BonDeLivraison_Lib");
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};
    String listeCrt[] = {"id","remarque","magasinlib","idFournisseurLib","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","magasinlib","daty","idFournisseurLib","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de r&eacute;ception");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondelivraison/bondelivraison-liste.jsp");
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }

    Liste[] liste = new Liste[1];
    Magasin magasinLib = new Magasin();
    magasinLib.setNomTable("MAGASIN2");
    liste[0] = new Liste("magasinlib", magasinLib, "val", "val");

    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("magasinlib").setLibelle("Magasin");
    pr.getFormu().getChamp("remarque").setLibelle("Remarque");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idFournisseurLib").setLibelle("Fournisseur");
    
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
        Map<String,String> lienTab=new HashMap();
        String[] id = {"daty1"};
        String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
        String classe = "faturefournisseur.As_BonDeLivraison";
        lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=bondelivraison/bondelivraison-liste.jsp&classe=" + classe + "&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
        lienTab.put("dupliquer",pr.getLien() + "?but=bondelivraison/bondelivraison-saisie.jsp&acte=dupliquer");
        pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondelivraison/bondelivraison-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setLienFille("bondelivraison/inc/bondelivraison-details.jsp&id=");
    pr.getTableau().setColonneLien(colonneLien);
    
    String libEnteteAffiche[] = {"ID","magasin","date", "fournisseur","remarque","&Eacute;tat" };
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=bondelivraison/bondelivraison-saisie.jsp&currentMenu=MNDN001804005\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'un bon de livraison</a>"
    );
%>
<script>
    function changerDesignation() {
        document.getElementById("bc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding">
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
            <br>
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
