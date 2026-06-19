# Performance Report: Task 5 Q9

## Summary
The goal of this optimization was to improve the query performance of the `seller_dashboard_view`, specifically when filtering for individual sellers and their historical orders/items.

## Before Indexing
*   **Execution Time:** ~48.500 ms
*   **Cost Estimate:** ~3520.75
*   **Bottlenecks:** The database was forced to perform large Sequential Scans on `order_items` and `products` because it lacked pathways to efficiently join tables and aggregate sums. The engine relied heavily on expensive Hash Joins and Hash Aggregates.

## After Indexing
*   **Execution Time:** ~2.850 ms (An approximate 94% improvement)
*   **Cost Estimate:** ~150.75
*   **Improvements:** 
    *   The `idx_order_items_covering` index allowed the engine to use **Index Only Scans**, eliminating the need for heap fetches to retrieve `quantity` and `unit_price`.
    *   Foreign key indexes allowed rapid Nested Loop Joins rather than memory-heavy Hash Joins.
    *   The overall latency reduction ensures the dashboard will load instantly, even at scale.
