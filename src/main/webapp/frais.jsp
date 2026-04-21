<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.dao.FraisDAO, mg.vola.models.FraisEnvoi, mg.vola.models.FraisRecep" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Grille Tarifaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --accent-rose: #F43F5E;
            --bg-page: #F1F5F9;
            --soft-radius: 12px;
            --border-color: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page);
            color: var(--main-dark);
        }

        .header-card {
            background: white;
            border-left: 6px solid var(--accent-mint);
            border-radius: var(--soft-radius);
        }

        .dashboard-container {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
        }

        /* --- DASHBOARD SWITCHER CORRIGÉ --- */
        .nav-section-switcher {
            display: flex;
            background: #CBD5E1; 
            padding: 6px;
            border-bottom: 1px solid var(--border-color);
        }

        .nav-section-switcher .nav-link {
            flex: 1;
            text-align: center;
            padding: 14px 20px;
            color: var(--main-dark) !important;
            font-weight: 700;
            border: none;
            border-radius: 10px;
            transition: all 0.25s ease;
            background: transparent;
            opacity: 1;
        }

        .nav-section-switcher .nav-link i { color: var(--main-dark); }

        .nav-section-switcher .nav-link:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.4);
        }

        .nav-section-switcher .nav-link.active {
            background: white;
            color: var(--main-dark) !important;
            box-shadow: 0 4px 12px rgba(15, 23, 42, 0.1);
        }

        .nav-link[data-bs-target="#tab-envoi"].active i { color: var(--accent-mint); }
        .nav-link[data-bs-target="#tab-recep"].active i { color: var(--accent-rose); }

        .price-badge {
            background: #DCFCE7;
            color: #065F46;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">
    <div class="header-card shadow-sm p-4 mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Grille Tarifaire</h2>
            <p class="mb-0 text-muted">Configuration des commissions d'envoi et de retrait</p>
        </div>
        <button class="btn btn-dark px-4 py-2 fw-bold" style="border-radius: 10px;" data-bs-toggle="collapse" data-bs-target="#formFrais">
            <i class="bi bi-plus-circle me-2"></i>Nouvelle tranche
        </button>
    </div>

    <div class="dashboard-container">
        <nav class="nav nav-section-switcher" role="tablist">
            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#tab-envoi" type="button">
                <i class="bi bi-send-fill me-2"></i>Frais d'envoi
            </button>
            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#tab-recep" type="button">
                <i class="bi bi-wallet2 me-2"></i>Frais de retrait
            </button>
        </nav>

        <div class="tab-content p-4">
            <% FraisDAO dao = new FraisDAO(); %>
            <div class="tab-pane fade show active" id="tab-envoi">
                <table class="table align-middle">
                    <thead><tr><th>Tranche</th><th>Commission</th></tr></thead>
                    <tbody>
                        <% for (FraisEnvoi e : dao.listerFraisEnv()) { %>
                        <tr>
                            <td class="text-navy fw-medium">De <%= e.getMontant1() %> à <%= e.getMontant2() %> Ar</td>
                            <td><span class="price-badge"><%= e.getFrais_env() %> Ar</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <div class="tab-pane fade" id="tab-recep">
                <table class="table align-middle">
                    <thead><tr><th>Tranche</th><th>Commission</th></tr></thead>
                    <tbody>
                        <% for (FraisRecep r : dao.listerFraisRec()) { %>
                        <tr>
                            <td class="text-navy fw-medium">De <%= r.getMontant1() %> à <%= r.getMontant2() %> Ar</td>
                            <td><span class="price-badge"><%= r.getFrais_rec() %> Ar</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>