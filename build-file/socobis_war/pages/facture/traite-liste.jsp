<%-- 
    Document   : client-quit-liste
    Created on : 31 oct. 2022, 12:14:22
    Author     : NAEPHA
--%>

<%@page import="java.sql.Date"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="facture.tr.Traite"%>
<%@page import="affichage.PageRecherche"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {
        Traite base = new Traite();
        base.setNomTable("TRAITEMTTRESTE");

		if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
            base.setNomTable(request.getParameter("etat"));
        }

        String[] etatVal = {"TRAITEMTTRESTE", "TRAITE_LIBC", "TRAITE_LIBV", "TRAITE_LIBESC", "TRAITE_LIBVER", "TRAITE_LIBNONENC", "TRAITE_LIBENC"};
        String[] etatAff = {"Tous", "Cr&eacute;&eacute;", "Vis&eacute;", "Escompt&eacute;", "Vers&eacute;", "Non encaiss&eacute;", "Encaiss&eacute;"};

        String listeCrt[] = {"id","tiers", "banque", "daty", "dateEcheance","reference"};
        String listeInt[] = {"daty", "dateEcheance"};
        String libEntete[] = {"id","tiers", "banque","reference", "daty", "dateEcheance","montant","montantreste","etatversementlib"};

        PageRecherche pr = new PageRecherche(base, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("tiers").setLibelle("Tiers");
        pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pr.getFormu().getChamp("banque").setLibelle("Banque");
        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("dateEcheance1").setLibelle("Date d'&eacute;ch&eacute;ance min");
        pr.getFormu().getChamp("dateEcheance2").setLibelle("Date d'&eacute;ch&eacute;ance max");
        pr.getFormu().getChamp("dateEcheance1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("dateEcheance2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.setOrdre(" order by tiers,dateEcheance asc");

        
        pr.setApres("facture/traite-liste.jsp");
        
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        pr.getFormu().setAnotherButton("" +
            "<a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=facture/traite-saisie.jsp&currentMenu=MEN000690\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir une traite</a>"
        );
%>
<script>
    function changerDesignation() {
        document.liste.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des traites</h1>
    </section>
    <section class="content">
        <form action='<%=pr.getLien() + "?but=facture/traite-liste.jsp" %>' method="post" name="liste" id="liste">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
			<div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
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
            String lienTableau[] = {pr.getLien() + "?but=facture/traite-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        <br/>
        <%
            String libelleAffiche[] = {"Id","Tiers", "Banque","r&eacute;f&eacute;rence","date","Date d'&eacute;ch&eacute;ance","Montant", "Montant Disponible","&Eacute;tat de versement"};
            pr.getTableau().setLibelleAffiche(libelleAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) {
        e.printStackTrace();
    }%>

