# Atliq Hardwares - Database Overview

## Overview

Atliq Hardwares is one of the leading computer hardware producers in India with a growing presence in international markets. This repository provides a comprehensive overview of the tables in the `atliq_hardware_db` (gdb023) database. The database contains six main tables related to customers, products, pricing, costs, pre-invoice deductions, and sales data.

The goal of this documentation is to provide you with an understanding of the structure and contents of the database, which can be used for data analysis, reporting, and decision-making.

## Tables in the Database

The following six tables are included in the `atliq_hardware_db` database:

1. **dim_customer**: Contains customer-related data.
2. **dim_product**: Contains product-related data.
3. **fact_gross_price**: Contains gross price information for each product.
4. **fact_manufacturing_cost**: Contains the cost incurred in the production of each product.
5. **fact_pre_invoice_deductions**: Contains pre-invoice deductions for each product.
6. **fact_sales_monthly**: Contains monthly sales data for each product.

---

## Table Details

### 1. **dim_customer**

This table contains information about customers, such as their identification, platform, and region.

| Column Name    | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `customer_code` | Unique identification codes for every customer. Example: '70002017', '90005160', '80007195'.                                               |
| `customer`      | Name of the customer, e.g., 'Atliq Exclusive', 'Flipkart', 'Surface Stores'.                                                                 |
| `platform`      | Sales platform: "Brick & Mortar" (physical store) or "E-Commerce" (online platform).                                                        |
| `channel`       | Distribution method: "Retailers", "Direct", or "Distributors".                                                                               |
| `market`        | Countries where the customer is located.                                                                                                     |
| `region`        | Geographic region of the customer: "APAC" (Asia Pacific), "EU" (Europe), "NA" (North America), "LATAM" (Latin America).                       |
| `sub_zone`      | Sub-region within the region, such as "India", "ROA" (Rest of Asia), "ANZ" (Australia and New Zealand), etc.                                 |

---

### 2. **dim_product**

This table provides information about products, including their categories, divisions, and variants.

| Column Name    | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `product_code` | Unique identification code for each product.                                                                                                 |
| `division`     | Product division: "P & A" (Peripherals and Accessories), "N & S" (Network and Storage), "PC" (Personal Computer).                           |
| `segment`      | Further categorization within the division: "Peripherals", "Accessories", "Notebook", "Desktop", "Storage", "Networking".                    |
| `category`     | Specific subcategory within the segment.                                                                                                     |
| `product`      | Name of the individual product.                                                                                                               |
| `variant`      | Product variant based on features and pricing: "Standard", "Plus", "Premium", etc.                                                            |

---

### 3. **fact_gross_price**

This table records the gross price for each product, including the fiscal year of sale.

| Column Name    | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `product_code` | Unique identification code for each product.                                                                                                 |
| `fiscal_year`  | Fiscal year in which the product sale was recorded. (Data available for FY 2020 and 2021).                                                     |
| `gross_price`  | Original selling price of the product before any deductions or taxes.                                                                        |

---

### 4. **fact_manufacturing_cost**

This table provides details about the manufacturing costs for each product.

| Column Name         | Description                                                                                                                                  |
|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `product_code`      | Unique identification code for each product.                                                                                                 |
| `cost_year`         | Fiscal year when the product was manufactured.                                                                                                |
| `manufacturing_cost`| The total cost incurred in the production of the product, including direct costs like raw materials, labor, and overhead.                       |

---

### 5. **fact_pre_invoice_deductions**

This table records pre-invoice deductions applied to each product, including discounts and reductions before the invoice is generated.

| Column Name            | Description                                                                                                                                 |
|------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `customer_code`         | Unique identification code for the customer.                                                                                               |
| `fiscal_year`           | Fiscal year when the product sale occurred.                                                                                               |
| `pre_invoice_discount_pct` | Percentage of pre-invoice deductions applied to the product. These deductions are typically applied to large orders or long-term contracts. |

---

### 6. **fact_sales_monthly**

This table contains monthly sales data, including the number of units sold for each product.

| Column Name    | Description                                                                                                                                  |
|----------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `date`         | The date when the sale of a product occurred, in monthly format for FY 2020 and 2021.                                                       |
| `product_code` | Unique identification code for each product.                                                                                                 |
| `customer_code`| Unique identification code for each customer.                                                                                               |
| `sold_quantity`| Number of units sold for each product in a specific month.                                                                                   |
| `fiscal_year`  | Fiscal year when the sale of a product occurred.                                                                                             |

---

## Use Cases

- **Sales Analysis**: By combining data from the `fact_sales_monthly`, `fact_gross_price`, and `fact_pre_invoice_deductions` tables, you can analyze the performance of different products across regions and channels.
  
- **Cost Analysis**: With the `fact_manufacturing_cost` and `fact_pre_invoice_deductions` tables, you can perform detailed cost analysis, compare manufacturing costs against sales prices, and identify profitable products.

- **Customer Insights**: Using the `dim_customer` table, you can identify which customer segments (platform, channel, region) contribute the most to overall sales and explore any trends or patterns.

## Conclusion

This documentation provides a high-level overview of the tables within the `atliq_hardware_db` database and their purpose. The database is designed to support business intelligence and data analytics tasks related to sales, costs, and customer behavior for Atliq Hardwares.

For any additional queries or if you need assistance with complex analysis, please feel free to reach out.

