<%@page import="paie.employe.PaieInfoPersonnelLib"%>
<%@page import="paie.employe.PaieInfoPersonnel"%>
<%@page import="bean.CGenUtil"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%
    String id = request.getParameter("id");
    String matricule = request.getParameter("matricule");
    UserEJB u = (UserEJB) session.getAttribute("u");
    PaieInfoPersonnelLib infopersonnel = new PaieInfoPersonnelLib();
    infopersonnel.setNomTable("paie_info_personnel_lib4");
    String personnelId = "AND ID= '" + id + "'";
    PaieInfoPersonnelLib[] infopersonnels = (PaieInfoPersonnelLib[]) u.getData(infopersonnel, null, null, null, personnelId);
    PaieInfoPersonnelLib infPers = null;
    if (infopersonnels.length > 0) {
        infPers = infopersonnels[0];
    }
%>
<div class="row">
    <div class="col-md-3">
    </div>
    <div class="col-md-6">
        <div class="box box-primary box-fiche">
            <div class="box-header with-border">
                <h1 class="box-title">Etat PDF</h1>
            </div>
            <div class="box-body">
                <table class="table table-bordered">
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=concluant&id=" + id %>" style="margin-right: 10px">Concluant</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=renouvellement&id=" + id %>" style="margin-right: 10px">Renouvellement</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=rupture&id=" + id %>" style="margin-right: 10px">Rupture de contrat</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=attestation&id=" + id %>" style="margin-right: 10px">Attestation de travail</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=certificat_mortalite&id=" + id %>" style="margin-right: 10px">Certificat de mortalit&eacute;</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=fin_periode_essai&id=" + id %>" style="margin-right: 10px">Fin de p&eacute;riode d'essai</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/pages/module.jsp?but=paie/contrat/contrat_travail.jsp&matricule="+ matricule %>" style="margin-right: 10px">Contrat de travail</a>
                        </th>
                    </tr>
                    <tr>
                        <th style="text-align: center" >
                            <a class="btn btn-primary"  href="<%="/fer/EtatReportJasper?action=notification_rupture&id=" + id %>" style="margin-right: 10px">Notififcation rupture de contrat</a>
                        </th>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-3">
    </div>
</div>