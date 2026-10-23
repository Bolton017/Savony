
<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="paie.avance.Avance"%>
<%@page import="utilitaire.Utilitaire"%> 
<%@page import="paie.avance.Remboursement"%>

<%
    try{
        String dossier = "op";
        String pageActuel = "paie/avance/remboursement-fiche.jsp";
        String lien = (String)session.getAttribute("lien");
        String id = request.getParameter("idavance"),
       nb_Remboursement = request.getParameter("nbremboursement"),
            colonneMere = request.getParameter("idpersonnel"),
            classeFille = "paie.avance.Remboursement",
            redirection = "paie/avance/remboursement-modif.jsp";
        Avance base = new Avance();
        base.setNomTable("AVANCE_LIB");
        PageConsulte pc = new PageConsulte(base, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("daty").setVisible(false);
        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("nbremboursement").setLibelle("Nombre de remboursements");
        pc.getChampByName("dateavance").setLibelle("Date de l'avance");
        pc.getChampByName("idtypeavance").setLibelle("Type de l'avance");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");


        base = (Avance) pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=prevision/prevision-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>Fiche de Remboursement</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">

                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer" >
                            <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/avance/remboursement-modif.jsp&id=" + request.getParameter("idavance")%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("idavance") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("idavance") %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
    <div>
        <jsp:include page='inc/liste-plan-remboursement.jsp'/>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>
</div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
  %>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
