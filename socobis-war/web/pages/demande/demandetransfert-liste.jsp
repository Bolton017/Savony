<%@page import="affichage.PageRecherche"%>
<%@page import="affichage.Liste"%>
<%@page import="magasin.Magasin"%>
<%@ page import="demande.DemandeTransfertCpl" %>
<%@ page import="prevision.Service" %>
<%@ page import="magasin.DirectionMagasinLib" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>
<% try{
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};

    DemandeTransfertCpl stock = new DemandeTransfertCpl();

    String listeCrt[] = {"id","designation","idDepartementDepart", "idDepartementArrive","idMagasinDepart","idMagasinArrive","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","designation","montantQuantite","idMagasinDepartlib","idMagasinArrivelib","idDepartementLibDepart", "idDepartementLibArrive","etatlib"};
    PageRecherche pr = new PageRecherche(stock, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des demandes de transferts de stocks");

    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    }


    // Initialisation Liste
    Liste[] listes = new Liste[4];
    Magasin m = new Magasin();
    m.setNomTable("magasin2");
    listes[0] = new Liste( "idMagasinDepart", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
    listes[1] = new Liste( "idMagasinArrive", new DirectionMagasinLib(), "idMagasinLib" , "idMagasin" );
    TypeObjet dep = new TypeObjet("DEPARTEMENT");
    listes[2] =  new Liste( "idDepartementDepart", dep, "val", "id");
    listes[2].setDeroulanteDependante(listes[0], "idDirection", "onchange");
    listes[3] = new Liste( "idDepartementArrive", dep, "val", "id");
    listes[3].setDeroulanteDependante(listes[1], "idDirection", "onchange");

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("demande/demandetransfert-liste.jsp");
    pr.getFormu().changerEnChamp( listes );
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idMagasinDepart").setLibelle("Magasin de d&eacute;part");
    pr.getFormu().getChamp("idMagasinArrive").setLibelle("Magasin d'arriv&eacute;e");
    pr.getFormu().getChamp("idDepartementDepart").setLibelle("D&eacute;partement de d&eacute;part");
    pr.getFormu().getChamp("idDepartementArrive").setLibelle("D&eacute;partement d'arriv&eacute;e");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] idAttributsLienTab = {"daty1"};
    String[] valAttributsLienTab = {pr.getFormu().getChamp("daty1").getValeur()};

    Map<String,String> lienTab=new HashMap();
    lienTab.put("viser", pr.getLien() +"?but=apresTarif.jsp&acte=valider&bute=demande/demandetransfert-liste.jsp&classe=demande.DemandeTransfert&rajoutLien="+ Utilitaire.ajouterParam(idAttributsLienTab, valAttributsLienTab));
    lienTab.put("modifier",pr.getLien() + "?but=demande/demandetransfert-saisie.jsp&acte=update");
    lienTab.put("dupliquer",pr.getLien() + "?but=demande/demandetransfert-saisie.jsp&acte=dupliquer");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=demande/demandetransfert-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Ref","Date","D&eacute;signation","Quantit&eacute;","Magasin de d&eacute;part","Magasin d'arriv&eacute;e","D&eacute;partement de d&eacute;part", "D&eacute;partement d'arriv&eacute;e","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton("" +
    "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=demande/demandetransfert-saisie.jsp&currentMenu=MNDN0000000032\">\n" +
    "                    <i class=\"material-symbols-rounded\">add</i>Saisie d'une demande de transfert </a>"
    );
    pr.getTableau().setLienFille("demande/inc/demandetransfertstockdetails-liste.jsp&id=");

%>

<script>
    function changerDesignation() {
        document.filtre.submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="filtre">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>

            <div class="row col-md-12">
                <div class="row">
                    <div class="col-md-4">
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
                </br>
            </div>

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
<%--<script>--%>
<%--    var tousOption = document.querySelector('#idDepartementDepart option[value="%"]');--%>
<%--    if (tousOption) {--%>
<%--        tousOption.remove();--%>
<%--    }--%>

<%--    var tousOption2 = document.querySelector('#idDepartementArrive option[value="%"]');--%>
<%--    if (tousOption2) {--%>
<%--        tousOption2.remove();--%>
<%--    }--%>
<%--</script>--%>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>