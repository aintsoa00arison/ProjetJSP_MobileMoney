<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="mg.vola.dao.TransactionDAO" %>
<%@ page import="mg.vola.models.Recette" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Tableau de Bord Recettes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --bg-page: #F1F5F9;
        }

        body { 
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page); 
            color: var(--main-dark);
        }

        /* --- STAT CARDS --- */
        .card-stat { 
            border-radius: 20px; 
            border: none; 
            transition: all 0.3s ease;
            overflow: hidden;
        }
        .card-stat:hover { transform: translateY(-7px); }
        
        .card-main {
            background: linear-gradient(135deg, var(--main-dark) 0%, #1e293b 100%);
            color: white;
        }

        .icon-box { 
            width: 55px; 
            height: 55px; 
            border-radius: 15px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 26px; 
        }

        /* --- DESIGN ELEMENTS --- */
        .header-section { 
            background: white; 
            border-left: 5px solid var(--accent-mint);
            border-radius: 15px;
        }

        .table-vola {
            background: white;
            border-radius: 20px;
            overflow: hidden;
        }
        .table thead { background-color: var(--main-dark); color: white; }
        .table thead th { border: none; padding: 18px; text-transform: uppercase; font-size: 0.8rem; }

        .btn-mint { background-color: var(--accent-mint); color: var(--main-dark); font-weight: 600; border: none; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">
    
    <%
        TransactionDAO dao = new TransactionDAO();
        Recette rec = dao.calculerRecettesGlobales(); 
    %>

    <div class="header-section shadow-sm p-4 mb-5">
        <h2 class="mb-0 fw-bold">Tableau des Revenus</h2>
        <p class="mb-0 text-muted">Analyse des commissions et bénéfices nets</p>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="card card-stat card-main shadow-lg p-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-uppercase mb-1" style="color: var(--accent-mint); opacity: 0.9;">Bénéfice Total</h6>
                        <h2 class="fw-bold mb-0"><%= String.format("%, d", rec.getBeneficeTotal()) %> Ar</h2>
                    </div>
                    <div class="icon-box" style="background: rgba(45, 212, 191, 0.2); color: var(--accent-mint);">
                        <i class="bi bi-graph-up-arrow"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat shadow-sm p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase mb-1 small fw-bold">Commissions Envois</h6>
                        <h2 class="fw-bold mb-0 text-dark"><%= String.format("%, d", rec.getTotalFraisEnvoi()) %> Ar</h2>
                    </div>
                    <div class="icon-box bg-light text-primary">
                        <i class="bi bi-box-arrow-up-right"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat shadow-sm p-4 bg-white">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted text-uppercase mb-1 small fw-bold">Commissions Retraits</h6>
                        <h2 class="fw-bold mb-0 text-dark"><%= String.format("%, d", rec.getTotalFraisRetrait()) %> Ar</h2>
                    </div>
                    <div class="icon-box bg-light text-danger">
                        <i class="bi bi-box-arrow-in-down-left"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="card table-vola border-0 shadow-sm p-4 mb-4">
                <h5 class="fw-bold mb-4">Détails de la comptabilité</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Catégorie</th>
                                <th>Description des flux</th>
                                <th class="text-end">Montant Cumulé</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <span class="badge rounded-pill px-3 py-2" style="background: rgba(45, 212, 191, 0.15); color: #0d9488;">
                                        Flux Envoi
                                    </span>
                                </td>
                                <td class="text-muted small">Commissions prélevées lors de l'expédition</td>
                                <td class="text-end fw-bold"><%= String.format("%, d", rec.getTotalFraisEnvoi()) %> Ar</td>
                            </tr>
                            <tr>
                                <td>
                                    <span class="badge rounded-pill px-3 py-2 bg-light text-danger">
                                        Flux Retrait
                                    </span>
                                </td>
                                <td class="text-muted small">Commissions déduites lors du retrait cash</td>
                                <td class="text-end fw-bold"><%= String.format("%, d", rec.getTotalFraisRetrait()) %> Ar</td>
                            </tr>
                        </tbody>
                        <tfoot class="table-light">
                            <tr style="border-top: 2px solid var(--main-dark);">
                                <td colspan="2" class="fw-bold py-3 ps-4">TOTAL DES RECETTES NETTES</td>
                                <td class="text-end text-primary fw-bold h4 py-3 pe-4" style="color: var(--main-dark) !important;">
                                    <%= String.format("%, d", rec.getBeneficeTotal()) %> Ar
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card border-0 shadow-sm p-4" style="border-radius: 20px; background: white;">
                <h6 class="fw-bold mb-3"><i class="bi bi-info-circle-fill text-primary me-2"></i>Note comptable</h6>
                <p class="small text-muted mb-4" style="line-height: 1.6;">
                    Les montants affichés reflètent les commissions stockées en base de données. 
                    <br><br>
                    <strong>Note :</strong> Les frais de retrait sont comptabilisés ici au moment où le bénéficiaire effectue le retrait physique de l'argent.
                </p>
                <div class="p-3 rounded-4" style="background: var(--bg-page); border: 1px solid #e2e8f0;">
                    <div class="d-flex align-items-center">
                        <div class="flex-shrink-0">
                            <i class="bi bi-shield-check text-success fs-4"></i>
                        </div>
                        <div class="ms-3">
                            <span class="d-block small fw-bold">Données Certifiées</span>
                            <span class="d-block x-small text-muted">Mise à jour en temps réel</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>