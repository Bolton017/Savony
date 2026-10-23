<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.avance.Avance" %>

<% 
    try{
    Avance lv = new Avance();
    lv.setNomTable("AVANCE_LIB2");

      
    String listeCrt[] = {"id", "dateavance","idtypeavancelib", "idpersonnel","matricule", "montant","interet","nbremboursement","etatlib"};
    String listeInt[] = {"dateavance","montant"};
    String libEntete[] = {"id", "dateavance","idtypeavancelib", "idpersonnel","matricule", "montant","interet", "nbremboursement","etatlib"};

    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        pr.setAWhere(pr.getAWhere()+" and etat"+String.valueOf(request.getParameter("etat")));
    } 

        Liste[] liste = new Liste[1];
        TypeObjet mp = new TypeObjet();
        liste[0] = new Liste("typeavance",mp,"val","id");
        pr.getFormu().changerEnChamp(liste);

    pr.setTitre("Liste des avances");

    pr.getFormu().getChamp("nbremboursement").setLibelle("nombre de remboursement");
    pr.getFormu().getChamp("dateavance1").setLibelle("Date de l'avance min");
    pr.getFormu().getChamp("dateavance2").setLibelle("Date de l'avance max");
    pr.getFormu().getChamp("montant1").setLibelle("Montant min");
    pr.getFormu().getChamp("montant2").setLibelle("Montant max");
    pr.getFormu().getChamp("idtypeavancelib").setLibelle("Type de l'avance");
    pr.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pr.getFormu().getChamp("etatlib").setVisible(false);
    pr.getFormu().getChamp("interet").setLibelle("Int&eacute;r&ecirc;t (%)");




        pr.setApres("paie/avance/avance-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
       String[] lienTableau = {pr.getLien() + "?but=paie/avance/avance-fiche.jsp"};
       String colonneLien[] = {"id"};
       pr.getTableau().setLien(lienTableau);
       pr.getTableau().setColonneLien(colonneLien);

        String libEnteteAffiche[] =  {"ID","Date de l'avance","Type de l'avance", "Personnel","Matricule", "Montant(Ar)","Int&eacute;r&ecirc;t (%)","Nombre de remboursement","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=paie/avance/avance-saisie.jsp&currentMenu=AMS007\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir un avance sur salaire" +
            "                </a>"
    );

    String[] etatVal = {"!= 100", "=1", "=11"};
    String[] etatAff = {"Tous", "Cr&eacute;&eacute;(s)", "Vis&eacute;(s)"};
    %>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
        
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            String currentEtat = request.getParameter("etat");
                            if (currentEtat == null || currentEtat.equals("")) {
                                currentEtat = "!= 100";
                            }
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(currentEtat)) {%>
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
        </br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception ex){
        ex.printStackTrace();
    }
%>