<%@page import="budget.UtilisateurService"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="faturefournisseur.DmdAchatLib" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.Liste" %>
<%@ page import="magasin.Magasin" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="utils.ConstanteSavonnerie" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    UserEJB u = (UserEJB) session.getValue("u");
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    String[] etatVal = {"","1","6","11", "8","10" , "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "VIS&Eacute;E par Direction Source","Vis&eacute;e(s) par DMT","VIS&Eacute;E par Initiateur","VIS&Eacute;E par Chef de D&eacute;partement" , "Annul&eacute;e(s)"};
    String[] prioriteVal = {"","P000001","P000002","P000003"};
    String[] prioriteAff = {"Tous","Imm&eacute;diate","Urgent","Normal"};

    DmdAchatLib o = new DmdAchatLib();
    String[] listeCrt = {"id","fournisseurlib","daty","remarque","idMagasinLib","idCategorieLib"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id", "daty","fournisseurlib","remarque","idMagasinLib","idCategorieLib","etatlib","idPrioriteLib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt,4, libEntete, libEntete.length);

    pr.setTitre("Liste des demandes d'achat");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("facturefournisseur/dmdachat/dmdachat-liste.jsp");
    String awhere = "";
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        awhere += " and etat=" + request.getParameter("etat");
    }
    if(request.getParameter("priorite")!=null && request.getParameter("priorite").compareToIgnoreCase("")!=0) {
        awhere += " and idPriorite = '" + request.getParameter("priorite")+"'";
    }
    UtilisateurService us = new UtilisateurService();
    us.setRefuser(u.getUser().getTuppleID());
    us = us.getUserService(null);
    boolean roleViewer = u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_DG)
        || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_CG)
        || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_CHEFFAB)
        || u.getUser().getIdrole().equalsIgnoreCase(ConstanteSavonnerie.ROLE_RESPACHAT);
    if (us != null && !roleViewer) {
        awhere += " and service='"+us.getIdService()+"'";
    }
    pr.setAWhere(awhere);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
//    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
//    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");

    Liste[] listes = new Liste[2];
    Magasin magasin = new Magasin();
    magasin.setNomTable("MAGASIN2");
    listes[0] = new Liste("idMagasinLib", magasin, "val", "val");
    CategorieIngredient categorieIngredient = new CategorieIngredient();
    categorieIngredient.setNomTable("CATEGORIEINGREDIENT");
    listes[1] = new Liste("idCategorieLib", categorieIngredient, "val", "val");
    pr.getFormu().changerEnChamp(listes);

    pr.getFormu().getChamp("idMagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("idCategorieLib").setLibelle("Cat&eacute;gorie");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    String[] id = {"daty1"};
    String[] val = {pr.getFormu().getChamp("daty1").getValeur()};
    String classe = "faturefournisseur.DmdAchat";
    lienTab.put("viser",pr.getLien() + "?but=apresTarif.jsp&acte=valider&bute=facturefournisseur/dmdachat/dmdachat-liste.jsp&classe=" + classe +"&rajoutLien="+ Utilitaire.ajouterParam(id, val) );
    lienTab.put("dupliquer",pr.getLien() + "?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);

    String[] lienTableau = {pr.getLien() + "?but=facturefournisseur/dmdachat/dmdachat-fiche.jsp"};
    String[] colonneLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("facturefournisseur/dmdachat/inc/dmdachat-details.jsp&id=");

    String[] libEnteteAffiche = {"ID", "Date","Fournisseur","Remarque","Magasin","Cat&eacute;gorie","&Eacute;tat","Priorit&eacute;"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=facturefournisseur/dmdachat/dmdachat-saisie.jsp&currentMenu=MNDN00110901146002\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une demande d'achat</a>"
    );

%>
<script>
    function changerDesignation() {
        document.getElementById("dmd-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="dmd-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 noppadding">
                <div class="col-md-2 noppadding">
                    <label class="input-label" for="etat">&Eacute;tat :</label>
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
                <div class="col-md-2 noppadding">
                    <label class="input-label" for="priorite">Priorit&eacute; :</label>
                    <select name="priorite" class="champ form-control" id="priorite" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < prioriteAff.length; i++ ){ %>
                        <% if(request.getParameter("priorite") !=null && request.getParameter("priorite").compareToIgnoreCase(prioriteVal[i]) == 0) {%>
                        <option value="<%= prioriteVal[i] %>" selected> <%= prioriteAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= prioriteVal[i] %>"> <%= prioriteAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
            <br>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
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