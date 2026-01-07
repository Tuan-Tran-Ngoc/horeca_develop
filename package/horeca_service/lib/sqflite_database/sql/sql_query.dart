class SQLQuery {
  // s_order
  static String SQL_ORD_001 = 'select * from s_order where order_id = ?';

  static String SQL_ORD_002 =
      'select * from s_order where customer_visit_id = ?';

  static String SQL_ORD_003 =
      'select tb01.order_cd, tb01.order_date, tb02.customer_code, tb02.customer_name'
      ", tb04.address_detail as address, tb01.remark"
      ', tb01.total_amount, tb01.total_discount, tb01.vat, tb01.grand_total_amount'
      ', tb01.po_no, tb01.expect_delivery_date, tb01.order_type, tb01.horeca_status'
      ' from s_order tb01'
      ' inner join m_customer tb02 on tb02.customer_id = tb01.customer_id'
      ' left join s_customer_visit tb03 on tb03.customer_visit_id = tb01.customer_visit_id'
      ' left join m_customer_address tb04 on tb04.customer_address_id = tb03.customer_address_id'
      ' where tb01.order_id = ?';

  //static String SQL_ORD_004 = 'select * from s_order where customer_id = ?';
  static String SQL_ORD_004 = ''' SELECT  
        so.order_id
        , so.order_cd
        , ca.address_detail as full_address
        , so.order_date
        , so.grand_total_amount
        , so.horeca_status
        FROM s_order so
        INNER JOIN s_customer_visit cs ON cs.customer_visit_id = so.customer_visit_id
        LEFT JOIN m_customer_address ca on ca.customer_address_id = cs.customer_address_id
        WHERE
        so.customer_id = ? 
        AND so.created_date >= date('now', '-30 days') 
        ORDER BY so.created_date DESC''';

  static String SQL_ORD_005 = '''
      SELECT  
        DISTINCT
              so.order_id
              , so.order_cd
              , ca.address_detail as full_address 
              , so.order_date
              , so.grand_total_amount 
              , so.horeca_status
              FROM s_order so
          inner join s_order_dtl sod on sod.order_id = so.order_id
          inner join m_product mp on mp.product_id = sod.product_id
              INNER JOIN s_customer_visit cs ON cs.customer_visit_id = so.customer_visit_id
              LEFT JOIN m_customer_address ca on ca.customer_address_id = cs.customer_address_id
              WHERE
              so.customer_id = ? 
              AND so.created_date >= date('now', '-30 days') 
          and (lower(mp.product_cd) like (?) or lower(mp.product_name) like (?))
              ORDER BY so.created_date DESC
            ''';

  static String SQL_ORD_006 = 'select tb01.*'
      'from s_order tb01'
      ' inner join s_order_dtl tb02 on tb01.order_id = tb02.order_id'
      ' inner join m_product tb03 on tb03.product_id = tb02.product_id'
      ' where tb01.customer_id = ?'
      " and tb03.product_cd like (?)";

  static String SQL_ORD_007 = 'select tb02.order_id from s_order tb01'
      ' inner join s_sap_order tb02 on tb02.order_no = tb01.sap_order_no'
      ' where tb01.order_id = ?';

  static String SQL_ORD_008 = 'select tb02.order_id from s_order tb01'
      ' inner join s_sap_order tb02 on tb02.order_no = tb01.sap_order_no'
      ' where tb01.order_id = ?';

  static String SQL_ORD_009 = 'select'
      ' tb02.order_no,'
      ' tb02.order_date,'
      ' tb02.customer_cd as customer_code,'
      ' tb02.customer_name,'
      " tb05.district_name || ', ' || tb06.province_name as address,"
      ' tb01.remark,'
      ' tb01.total_amount,'
      ' tb01.total_discount,'
      ' tb02.total_net_value as grand_total_amount,'
      ' tb02.po_hrc as po_no,'
      ' tb01.expect_delivery_date,'
      ' tb02.status as horeca_status'
      ' from s_order tb01'
      ' inner join s_sap_order tb02 on tb02.order_no = tb01.sap_order_no'
      ' left join s_customer_visit tb03 on tb03.customer_visit_id = tb01.customer_visit_id'
      ' left join m_customer_address tb04 on tb04.customer_address_id = tb03.customer_address_id'
      ' left join m_district tb05 on tb05.district_id = tb04.district_id'
      ' left join m_province tb06 on tb06.province_id = tb04.province_id'
      ' where tb01.order_id = ?';

  static String SQL_ORD_010 =
      '''select IFNULL(sum(grand_total_amount),0.0) as grand_total_amount from s_order
where horeca_status not in ('01','05') 
and customer_id = ?
and date(order_date) = date('now')''';

  // s_order_dtl
  static String SQL_ORD_DTL_001 =
      'select * from s_order_dtl where order_id = ?';

  static String SQL_ORD_DTL_002 =
      '''select tb04.product_cd, tb04.product_name, SUM(tb03.qty) AS total_qty, SUM(tb03.total_amount) AS total_amount
       from s_customer_visit tb01
       inner join s_order tb02 on tb02.customer_visit_id = tb01.customer_visit_id
       inner join s_order_dtl tb03 on tb03.order_id = tb02.order_id
       inner join m_product tb04 on tb04.product_id = tb03.product_id
       where tb01.shift_report_id = ?
	   and tb01.customer_id = ?
	   and tb01.customer_address_id = ?
	   group by tb04.product_id,tb04.product_cd, tb04.product_name
	   order by tb04.product_id desc''';

  static String SQL_ORD_DTL_003 =
      'select tb02.product_name,  tb01.qty as quantity, tb03.uom_name, tb01.sales_price as price_cost'
      ', tb01.sales_in_price as price_cost_discount, tb01.total_amount'
      ' from s_order_dtl tb01'
      ' inner join m_product tb02 on tb02.product_id = tb01.product_id'
      ' inner join m_uom tb03 on tb03.uom_id = tb02.uom_id'
      ' where order_id = ?';

  static String SQL_ORD_DTL_004 =
      '''select tb04.product_cd, tb04.product_name, SUM(tb03.qty) AS total_qty, SUM(tb03.total_amount) AS total_amount
        from s_customer_visit tb01
        inner join s_order tb02 on tb02.customer_visit_id = tb01.customer_visit_id
        inner join s_order_dtl tb03 on tb03.order_id = tb02.order_id
        inner join m_product tb04 on tb04.product_id = tb03.product_id
       where tb01.shift_report_id = ?
          and tb01.customer_id = ?
          group by tb04.product_id,tb04.product_cd, tb04.product_name
          order by tb04.product_id desc''';

  // m_account
  static String SQL_ACC_001 = 'select *from m_account where username = ?';

  // m_account_position_link
  static String SQL_ACC_POS_LIK_001 =
      'select *from m_account_position_link where account_id = ?';

  // m_shift
  static String SQL_SHIFT_001 = 'select *from m_shift where status = ?';

  // m_employee_position_link
  static String SQL_EMPLOY_POS_LIK_001 =
      'select * from m_employee_position_link where position_id = ?';

  // m_employee
  static String SQL_EMP_001 =
      '''select tb02.employee_id, tb02.employee_name from
      m_employee_position_link tb01
      inner join m_employee tb02 ON tb02.employee_id = tb01.employee_id
      where tb01.position_id = ?''';

  // s_shift_report
  static String SQL_SFT_RP_001 =
      'select *from s_shift_report where ba_position_id = ? and end_time is null';

  static String SQL_SFT_RP_002 =
      'select *from s_shift_report where shift_report_id = ?';

  static String SQL_SFT_RP_003 =
      "select *from s_shift_report where date(working_date) = date('now','localtime') and shift_code = ?";

  // s_customer_visit
  // static String SQL_CUS_VST_001 = '''SELECT
  //      tb03.route_id,
  //      tb04.customer_id,
  //      tb04.customer_code,
  //      tb04.customer_name,
  //      tb02.shift_code,
  //      tb02.shift_name,
  //      tb05.customer_visit_id,
  //      tb05.visit_date,
  //      tb05.start_time,
  //      tb05.end_time,
  //      tb05.visit_times,
  //      tb03.day_of_week,
  //      tb05.visit_status
  //      FROM s_shift_report tb01
  //      inner join m_shift tb02 ON tb02.shift_code = tb01.shift_code
  //      inner join m_route_assignment tb03 ON tb03.shift_code = tb01.shift_code
  //      AND tb03.day_of_week = (strftime('%w', tb01.working_date) + 1)
  //      inner join m_customer tb04 ON tb04.customer_id = tb03.customer_id
  //      left join s_customer_visit tb05 ON tb05.shift_report_id = tb01.shift_report_id
  //      AND tb05.customer_id = tb04.customer_id
  //      WHERE tb01.shift_report_id = ?
  //      and (tb03.frequency = '00'
  //      or  (strftime('%W', tb01.working_date) % 2  = 0  and tb03.frequency = '01')
  //      or  (strftime('%W', tb01.working_date) % 2  = 1  and tb03.frequency = '02'))''';

  static String SQL_CUS_VST_001 = '''SELECT
                tb03.route_id,
                tb04.customer_id,
                tb04.customer_code,
                tb04.customer_name,
                tb02.shift_code,
                tb02.shift_name,
                tb05.customer_visit_id,
                IFNULL(tb05.visit_date,tb01.working_date) as visit_date,
                tb05.start_time,
                tb05.end_time,
                tb05.visit_times,
                tb03.day_of_week,
                tb05.visit_status,
                tb05.parent_customer_visit_id
                FROM s_shift_report tb01
                inner join m_shift tb02 ON tb02.shift_code = tb01.shift_code
                inner join m_route_assignment tb03 ON tb03.shift_code = tb01.shift_code 
                                                  and tb03.ba_position_id = tb01.ba_position_id
                                                  AND tb03.day_of_week = (strftime('%w', tb01.working_date) + 1)
                inner join m_customer tb04 ON tb04.customer_id = tb03.customer_id
                                           AND tb04.status = '01'
                left join s_customer_visit tb05 ON tb05.shift_report_id = tb01.shift_report_id
                AND tb05.customer_id = tb04.customer_id
                WHERE tb01.shift_report_id = ?
                and (tb03.frequency = '00'
                or  (strftime('%W', tb01.working_date) % 2  = 0  and tb03.frequency = '01')
                or  (strftime('%W', tb01.working_date) % 2  = 1  and tb03.frequency = '02'))
                and date(tb01.working_date) BETWEEN date(tb03.start_date) AND date(tb03.end_date)
              union
                SELECT
                      0 as route_id,
                      tb04.customer_id,
                      tb04.customer_code,
                      tb04.customer_name,
                      tb03.shift_code,
                      tb03.shift_name,
                      tb02.customer_visit_id,
                      tb02.visit_date,
                      tb02.start_time,
                      tb02.end_time,
                      tb02.visit_times,
                      strftime('%w', tb02.visit_date) + 1 as day_of_week,
                      tb02.visit_status,
                      tb02.parent_customer_visit_id
                      FROM s_shift_report tb01
                      inner join s_customer_visit tb02 ON tb02.shift_report_id = tb01.shift_report_id
                      inner join m_shift tb03 ON tb03.shift_code = tb02.shift_code
                      left join m_customer tb04 ON tb04.customer_id = tb02.customer_id
                                                 AND tb04.status = '01'
                      WHERE tb01.shift_report_id = ?
                      AND NOT EXISTS (
                        SELECT ra.customer_id
                        FROM s_shift_report sr
                        INNER JOIN m_route_assignment ra ON ra.shift_code = sr.shift_code
                                                        AND ra.ba_position_id = sr.ba_position_id
                        WHERE ra.day_of_week = (strftime('%w', sr.working_date) + 1)
                        AND (ra.frequency = '00'
                          OR (strftime('%W', sr.working_date) % 2 = 0 AND ra.frequency = '01')
                          OR (strftime('%W', sr.working_date) % 2 = 1 AND ra.frequency = '02')) 
                        AND sr.shift_report_id = tb01.shift_report_id
                        AND ra.customer_id = tb04.customer_id
                        and date(sr.working_date) BETWEEN date(ra.start_date) AND date(ra.end_date)
                      )
          ''';

  // static String SQL_CUS_VST_004 = '''select
  //      tb01.route_id
  //     , tb03.customer_id
  //     , tb03.customer_code
  //     , tb03.customer_name
  //     , tb02.shift_name
  //     , tb04.customer_visit_id
  //     , tb04.visit_date
  //     , tb04.start_time
  //     , tb04.end_time
  //     , tb04.visit_times
  //     , tb04.visit_status
  //      FROM m_route_assignment tb01
  //      inner join m_shift tb02 on tb02.shift_code = tb01.shift_code
  //      inner join m_customer tb03 ON tb03.customer_id = tb01.customer_id
  //      left join s_customer_visit tb04 ON tb04.customer_id = tb01.customer_id
  //      and tb04.shift_report_id = ? and tb01.shift_code = tb04.shift_code
  //      and (strftime('%w', tb04.visit_date) + 1) = tb01.day_of_week
  //      Where
  //       tb03.customer_name like (?)
  //      AND tb01.day_of_week in (#lstDays#)
  //      AND tb02.shift_code in (#lstShift#)
  //      order by tb02.shift_code desc''';

  static String SQL_CUS_VST_004 = '''select
       distinct
       tb03.customer_id
      , tb03.customer_code
      , tb03.customer_name
      , tb02.shift_name
	    , tb01.day_of_week
      , tb04.customer_visit_id
      , tb04.visit_date
      , tb04.start_time
      , tb04.end_time
      , tb04.visit_times
      , tb04.visit_status
      , tb04.parent_customer_visit_id
	  ,tb05.working_date
       FROM m_route_assignment tb01
       inner join m_shift tb02 on tb02.shift_code = tb01.shift_code
       left join m_customer tb03 ON tb03.customer_id = tb01.customer_id
                                  AND tb03.status = '01'
       left join s_customer_visit tb04 ON tb04.customer_id = tb01.customer_id
       and tb04.shift_report_id = ?
	     left join s_shift_report tb05 ON tb05.shift_report_id = ?
       Where
        (tb03.customer_name like (?) or tb03.customer_code like (?))
       AND tb01.day_of_week in (#lstDays#)
       AND tb01.shift_code in (#lstShift#)
	   AND (tb01.frequency = '00'
                or  (strftime('%W', tb05.working_date) % 2  = 0  and tb01.frequency = '01')
                or  (strftime('%W', tb05.working_date) % 2  = 1  and tb01.frequency = '02'))''';

  static String SQL_CUS_VST_005 = '''SELECT 
 count(*)
       FROM s_shift_report tb01
       inner join m_shift tb02 ON tb02.shift_code = tb01.shift_code
       inner join m_route_assignment tb03 ON tb03.shift_code = tb01.shift_code
       AND tb03.day_of_week = (strftime('%w', tb01.working_date) + 1)
       AND date(tb01.working_date) between date(tb03.start_date) and date(tb03.end_date)
       inner join m_customer tb04 ON tb04.customer_id = tb03.customer_id
       WHERE tb01.shift_report_id = ?
       and (tb03.frequency = '00'
       or  (strftime('%W', tb01.working_date) % 2  = 0  and tb03.frequency = '01')
       or  (strftime('%W', tb01.working_date) % 2  = 1  and tb03.frequency = '02'))''';

  static String SQL_CUS_VST_006 = '''select *from s_customer_visit
  where shift_report_id = ? and customer_id = ? and customer_address_id = ? order by customer_visit_id desc''';

  static String SQL_CUS_VST_007 = '''select count(*) from  s_customer_visit 
where shift_report_id = ? 
and visit_status = ?''';

  static String SQL_CUS_VST_008 =
      '''select max(customer_visit_id) from s_customer_visit where customer_address_id = ? and customer_id = ? and customer_visit_id != ?''';

  // s_customer_visit
  static String SQL_CUS_VIS_001 = '''select * from s_customer_visit
      where shift_report_id = ?
      and customer_id = ?
      and customer_visit_id = ?''';

  static String SQL_CUS_VST_002 =
      'Select *from s_customer_visit where customer_id = ? and end_time is null';

  static String SQL_CUS_VST_003 =
      'select * from s_customer_visit where customer_visit_id = ?';

  // s_customer_address
  static String SQL_CUS_ADR_001 =
      '''select tb02.customer_address_id, tb02.address_detail as address
       from m_customer tb01
       inner join m_customer_address tb02 on tb02.customer_id = tb01.customer_id
       where tb01.customer_id = ?
       and current_timestamp BETWEEN IFNULL(tb02.address_start_date , current_timestamp) AND IFNULL(tb02.address_end_date , current_timestamp)''';

  static String SQL_CUS_ADR_002 =
      "select tb02.address_detail as address from s_customer_visit tb01"
      ' inner join m_customer_address tb02 on tb02.customer_address_id = tb01.customer_address_id'
      ' where tb01.customer_visit_id = ?';

  // m_product
  // static String SQL_PRD_001 =
  //     'SELECT tb01.*, tb02.type_name, tb03.uom_name FROM m_product tb01'
  //     ' inner join m_product_type tb02 on tb02.product_type_id = tb01.product_type_id'
  //     ' inner join m_uom tb03 on tb03.uom_id = tb01.uom_id'
  //     ' where  tb01.is_salable = 1';
  static String SQL_PRD_001 = '''SELECT
        tb01.product_id,
        tb01.product_cd,
        tb01.product_name,
        tb01.brand_id,
        tb01.product_img,
        tb02.type_name,
        tb03.uom_name,
        grp02.latest_price AS price_cost
    FROM
      w_stock_balance sb
    inner join m_product tb01 on sb.product_id = tb01.product_id
    INNER JOIN
        m_product_type tb02 ON tb02.product_type_id = tb01.product_type_id
    INNER JOIN
        m_uom tb03 ON tb03.uom_id = tb01.uom_id
    LEFT JOIN (
        select 
					grp01.customer_id,
                  grp01.product_id,
                  grp01.latest_price,
				  ROW_NUMBER() OVER (PARTITION BY grp01.product_id ORDER BY grp01.updated_date DESC) AS rn
			  from(
				SELECT
                  tb04.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customer tb04 ON tb04.customer_id = tb02.target_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '00'
                  AND tb04.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customer_property tb04 ON tb04.customer_property_id = tb02.target_id
              INNER JOIN
                  m_customer_property_mapping tb05 ON tb05.customer_property_id = tb04.customer_property_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '01'
                  AND tb05.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_area tb04 ON tb04.area_id = tb02.target_id
              INNER JOIN
                  m_customer tb05 ON tb05.area_id = tb04.area_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '02'
                  AND tb05.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customers_group tb04 ON tb04.customers_group_id = tb02.target_id
              INNER JOIN
                  m_customers_group_detail tb05 ON tb05.customers_group_id = tb04.customers_group_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '03'
                  AND tb05.customer_id = ?
			  ) grp01
    ) AS grp02 ON tb01.product_id = grp02.product_id AND grp02.rn = 1
    WHERE
        date(sb.allocate_date) = date('now')
		    and sb.position_id = ?
        and tb01.is_salable = 1
        and tb01.status = '01'
    ORDER BY sb.available_stock desc, tb01.priority asc''';

  // s_customer_stock
  // static String SQL_CUS_PRI_001 = '''select
  //      tb04.product_id,
  //      tb04.product_name,
  //      tb05.type_name,
  //      tb06.uom_name,
  //      tb02.customer_stock_id,
  //      tb03.customer_price_id,
  //      tb03.price as price_customer,
  //      tb02.available_stock as quantity
  //      from
  //      s_customer_visit tb01
  //      inner join s_customer_stock tb02 on tb02.customer_visit_id = tb01.customer_visit_id
  //      and tb02.customer_id = tb01.customer_id
  //      inner join s_customer_price tb03 on tb03.customer_visit_id = tb02.customer_visit_id
  //      and tb03.customer_id = tb02.customer_id
  //      and tb03.product_id = tb02.product_id
  //      inner join m_product tb04 on tb04.product_id = tb03.product_id
  //      inner join m_product_type tb05 on tb05.product_type_id= tb04.product_type_id
  //      inner join m_uom tb06 on tb06.uom_id = tb04.uom_id
  //      where tb01.customer_visit_id = ?
  //      and tb01.customer_id = ?''';

  static String SQL_CUS_PRI_001 = '''select
		tb01.customer_visit_id,
       tb04.product_id,
       tb04.product_name,
       tb05.type_name,
       tb06.uom_name,
       tb02.customer_stock_id,
       tb03.customer_price_id,
       tb03.price as price_customer,
       tb02.available_stock as quantity
       from
       s_customer_visit tb01
       inner join s_customer_stock tb02 on tb02.customer_visit_id = tb01.customer_visit_id
       and tb02.customer_id = tb01.customer_id
       inner join s_customer_price tb03 on tb03.customer_visit_id = tb02.customer_visit_id
       and tb03.customer_id = tb02.customer_id
       and tb03.product_id = tb02.product_id
       inner join m_product tb04 on tb04.product_id = tb03.product_id
       inner join m_product_type tb05 on tb05.product_type_id= tb04.product_type_id
       inner join m_uom tb06 on tb06.uom_id = tb04.uom_id
       where
	   tb01.customer_address_id = ?
       and tb01.customer_id = ?
	   and tb01.updated_date = (
			select max(updated_date) from s_customer_visit where customer_address_id = ? and customer_id = ?
	   )''';

  // m_customer
  static String SQL_CUS_001 = 'Select *from m_customer where customer_id = ?';

  // m_customer_liabilities
  static String SQL_CUS_LIA_001 =
      'select *from m_customer_liabilities where customer_code = ?';

  // m_promotion
  // static String SQL_PRO_001 =
  //     "select tb02.promotion_id, tb02.promotion_code, tb02.promotion_name, tb02.promotion_type, strftime('%d/%m/%Y', substr(tb02.start_date, 1, 10)) as start_date, strftime('%d/%m/%Y', substr(tb02.end_date, 1, 10)) as end_date"
  //     ' from m_promotion_target tb01'
  //     ' inner join m_promotion tb02 ON tb02.promotion_id = tb01.promotion_id'
  //     ' where tb01.target_type = ?'
  //     ' and tb01.target_id = ?'
  //     ' and tb02.status = ?'
  //     " and date('now') BETWEEN date(tb02.start_date) and date(tb02.end_date)";
  static String SQL_PRO_001 = '''select *FROM
      (SELECT
                  tb01.promotion_id
            , tb01.promotion_code
            , tb01.promotion_name
            , tb01.condition_type
			      , tb01.promotion_type
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
            , tb01.remark
              FROM
                  m_promotion tb01
              INNER JOIN
                  m_promotion_target tb02 ON tb02.promotion_id = tb01.promotion_id
              INNER JOIN
                  m_customer tb04 ON tb04.customer_id = tb02.target_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '00'
                  AND tb04.customer_id = ?
      UNION
      SELECT
               tb01.promotion_id
            , tb01.promotion_code
            , tb01.promotion_name
            , tb01.condition_type
			      , tb01.promotion_type
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
            , tb01.remark
              FROM
                  m_promotion tb01
              INNER JOIN
                  m_promotion_target tb02 ON tb02.promotion_id = tb01.promotion_id
              INNER JOIN
                  m_customer_property tb04 ON tb04.customer_property_id = tb02.target_id
              INNER JOIN
                  m_customer_property_mapping tb05 ON tb05.customer_property_id = tb04.customer_property_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '01'
                  AND tb05.customer_id = ?
      UNION
      SELECT
               tb01.promotion_id
            , tb01.promotion_code
            , tb01.promotion_name
            , tb01.condition_type
			      , tb01.promotion_type
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
            , tb01.remark
              FROM
                  m_promotion tb01
              INNER JOIN
                  m_promotion_target tb02 ON tb02.promotion_id = tb01.promotion_id
              INNER JOIN
                  m_area tb04 ON tb04.area_id = tb02.target_id
              INNER JOIN
                  m_customer tb05 ON tb05.area_id = tb04.area_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '02'
                  AND tb05.customer_id = ?
      UNION
      SELECT
               tb01.promotion_id
            , tb01.promotion_code
            , tb01.promotion_name
            , tb01.condition_type
			      , tb01.promotion_type
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
            , tb01.remark
              FROM
                  m_promotion tb01
              INNER JOIN
                  m_promotion_target tb02 ON tb02.promotion_id = tb01.promotion_id
              INNER JOIN
                  m_customers_group tb04 ON tb04.customers_group_id = tb02.target_id
              INNER JOIN
                  m_customers_group_detail tb05 ON tb05.customers_group_id = tb04.customers_group_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '03'
                  AND tb05.customer_id = ?)
      order by start_date desc''';

  static String SQL_PRO_002 = '''select tb01.promotion_id
      , tb02.promotion_scheme_id
      , tb05.product_id as condition_product_id
      , tb03.promotion_condition_id
      , tb05.product_name as condition_product_name
      , tb03.condition_qty
      , tb06.product_id as result_product_id
      , tb04.promotion_result_id as promotion_result_id
      , tb06.product_name as result_product_name
      , tb04.result_qty
      , tb03.total_type
       from m_promotion tb01
       inner join m_promotion_scheme tb02 on tb02.promotion_id = tb01.promotion_id
       inner join m_promotion_condition tb03 on tb03.promotion_id = tb02.promotion_id and tb03.promotion_scheme_id = tb02.promotion_scheme_id
       inner join m_promotion_result tb04 on tb04.promotion_id = tb02.promotion_id and tb04.promotion_scheme_id = tb02.promotion_scheme_id
       left join m_product tb05 on tb05.product_id = tb03.product_id
       left join m_product tb06 on tb06.product_id = tb04.product_id
       where tb01.promotion_id = ?
       order by tb02.promotion_scheme_id''';

  // static String SQL_PRO_003 =
  //     'select tb02.promotion_id, tb02.promotion_code, tb02.promotion_name, tb03.promotion_scheme_id, tb02.condition_type, tb02.promotion_type'
  //     ' from m_promotion_target tb01'
  //     ' inner join m_promotion tb02 ON tb02.promotion_id = tb01.promotion_id'
  //     ' inner join m_promotion_scheme tb03 ON tb02.promotion_id = tb03.promotion_id'
  //     ' where tb01.target_type = ?'
  //     ' and tb01.target_id = ?'
  //     ' and tb02.status = ?'
  //     " and date('now') BETWEEN date(tb02.start_date) and date(tb02.end_date)";
  static String SQL_PRO_003 = '''select tb01.promotion_id
                , tb01.promotion_code
                , tb01.promotion_name
                , tb02.promotion_scheme_id
                , tb01.condition_type
                , tb01.promotion_type
                      from m_promotion tb01
                      inner join m_promotion_scheme tb02 ON tb02.promotion_id = tb01.promotion_id
                      where tb01.promotion_id in (#lstPromotionId#)''';

  static String SQL_PRO_004 =
      'select tb02.product_name , tb01.qty as result_qty, tb01.description as scheme_content'
      ' from s_order_promotion_result tb01'
      ' inner join m_product tb02 on tb02.product_id = tb01.product_id'
      ' where tb01.order_id = ?'
      ' order by tb01.created_date desc';

  // m_discount
  static String SQL_DIS_001 = '''select *FROM
      (SELECT
                  tb01.discount_id
            , tb01.discount_code
            , tb01.discount_name
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
              FROM
                  m_discount tb01
              INNER JOIN
                  m_discount_target tb02 ON tb02.discount_id = tb01.discount_id
              INNER JOIN
                  m_customer tb04 ON tb04.customer_id = tb02.target_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '00'
                  AND tb04.customer_id = ?
      UNION
      SELECT
                    tb01.discount_id
            , tb01.discount_code
            , tb01.discount_name
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
              FROM
                  m_discount tb01
              INNER JOIN
                  m_discount_target tb02 ON tb02.discount_id = tb01.discount_id
              INNER JOIN
                  m_customer_property tb04 ON tb04.customer_property_id = tb02.target_id
              INNER JOIN
                  m_customer_property_mapping tb05 ON tb05.customer_property_id = tb04.customer_property_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '01'
                  AND tb05.customer_id = ?
      UNION
      SELECT
                  tb01.discount_id
            , tb01.discount_code
            , tb01.discount_name
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
              FROM
                  m_discount tb01
              INNER JOIN
                  m_discount_target tb02 ON tb02.discount_id = tb01.discount_id
              INNER JOIN
                  m_area tb04 ON tb04.area_id = tb02.target_id
              INNER JOIN
                  m_customer tb05 ON tb05.area_id = tb04.area_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '02'
                  AND tb05.customer_id = ?
      UNION
      SELECT
                  tb01.discount_id
            , tb01.discount_code
            , tb01.discount_name
            , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
            , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
              FROM
                  m_discount tb01
              INNER JOIN
                  m_discount_target tb02 ON tb02.discount_id = tb01.discount_id
              INNER JOIN
                  m_customers_group tb04 ON tb04.customers_group_id = tb02.target_id
              INNER JOIN
                  m_customers_group_detail tb05 ON tb05.customers_group_id = tb04.customers_group_id
              WHERE
                  date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '03'
                  AND tb05.customer_id = ?)
      order by start_date desc''';

  static String SQL_DIS_002 = 'select tb01.discount_id'
      ', tb01.condition_type'
      ', tb02.discount_scheme_id'
      ', tb05.product_id as condition_product_id'
      ', tb03.discount_condition_id'
      ', tb05.product_name as condition_product_name'
      ', tb03.total_type'
      ', tb03.condition_qty'
      ', tb03.total_type'
      ', tb04.discount_result_id as discount_result_id'
      ', tb04.discount_type'
      ', tb04.result_qty'
      ' from m_discount tb01'
      ' inner join m_discount_scheme tb02 on tb02.discount_id = tb01.discount_id'
      ' inner join m_discount_condition tb03 on tb03.discount_id = tb02.discount_id and tb03.discount_scheme_id = tb02.discount_scheme_id'
      ' inner join m_discount_result tb04 on tb04.discount_id = tb02.discount_id and tb04.discount_scheme_id = tb02.discount_scheme_id'
      ' left join m_product tb05 on tb05.product_id = tb03.product_id'
      ' where tb01.discount_id = ?';

  static String SQL_DIS_003 =
      'select tb02.discount_id, tb02.discount_code, tb02.discount_name, tb03.discount_scheme_id'
      'from m_discount_target tb01'
      'inner join m_discount tb02 ON tb02.discount_id = tb01.discount_id'
      'inner join m_discount_scheme tb03 ON tb02.discount_id = tb03.discount_id'
      'where tb01.target_type = ?'
      'and tb01.target_id = ?'
      'and tb02.status = ?'
      "and date('now') BETWEEN date(tb02.start_date) and date(tb02.end_date)";

  static String SQL_DIS_004 = '''select
      tb01.discount_id,
      tb01.condition_type,
      tb01.discount_code,
      tb01.discount_name,
      tb03.discount_scheme_id,
      tb04.product_id,
      tb04.total_type,
      tb04.condition_qty,
      tb05.discount_type,
      tb05.result_qty
      from m_discount tb01
      inner join m_discount_scheme tb03 on tb03.discount_id = tb01.discount_id
      inner join m_discount_condition tb04 on tb04.discount_id = tb03.discount_id and tb04.discount_scheme_id = tb03.discount_scheme_id
      inner join m_discount_result tb05 on tb05.discount_id = tb03.discount_id and tb05.discount_scheme_id = tb03.discount_scheme_id
      where 
       date('now') BETWEEN date(tb01.start_date) and date(tb01.end_date)
      and tb01.status = '01'
      and tb01.condition_type = ?
	  and tb01.discount_id in (#lstDiscountId#)''';

  static String SQL_DIS_005 =
      '''select tb02.condition_type, tb01.discount_type , tb01.total_discount, tb01.description as remark
      from s_order_discount_result tb01
	  inner join m_discount tb02 on tb01.discount_id = tb02.discount_id
       where tb01.order_id = ?
      order by tb01.created_date desc''';

  // m_promotion_scheme
  static String SQL_PRO_SCH_001 =
      '''select tb01.promotion_id as program_id, tb01.promotion_scheme_id as scheme_id, tb02.product_id, tb03.product_name,tb02.result_qty from m_promotion_scheme tb01
       inner join m_promotion_result tb02 on tb01.promotion_id = tb02.promotion_id
       inner join m_product tb03 on tb03.product_id = tb02.product_id
       where tb01.promotion_scheme_id  = ?
      order by tb01.promotion_scheme_id desc''';

  static String SQL_PRO_SCH_002 =
      '''select tb02.promotion_id, tb02.promotion_scheme_id from m_promotion tb01
          inner join m_promotion_scheme tb02 on tb02.promotion_id = tb01.promotion_id
          where tb01.promotion_id = ?''';

  // m_promotion_condition
  static String SQL_PRO_COND_001 =
      'select total_type, product_id, condition_qty from m_promotion_condition where promotion_id = ? and promotion_scheme_id = ?';

  static String SQL_PRO_COND_002 = '''select tb01.promotion_condition_id
	, tb01.product_id
	, tb02.product_name
	, tb01.total_type
	, tb01.condition_qty 
	from m_promotion_condition tb01
	left join m_product tb02 on tb02.product_id = tb01.product_id
	where tb01.promotion_id = ? and tb01.promotion_scheme_id = ?''';

  // m_promotion_result
  static String SQL_PRO_RES_001 =
      'select tb01.product_id, tb02.product_name, tb01.result_qty from m_promotion_result tb01 left join m_product tb02 on tb02.product_id = tb01.product_id where tb01.promotion_id = ? and tb01.promotion_scheme_id = ?';

  static String SQL_PRO_RES_002 = '''select tb01.promotion_result_id
	, tb01.product_id
	, tb02.product_name
	, tb01.result_qty 
	from m_promotion_result tb01
	left join m_product tb02 on tb02.product_id = tb01.product_id
	where tb01.promotion_id = ? and tb01.promotion_scheme_id = ?''';

  // m_discount_condition
  static String SQL_DIS_COND_001 =
      'select product_id, condition_qty from m_discount_condition where discount_id = ? and discount_scheme_id = ?';

  // m_discount_result
  static String SQL_DIS_RES_001 =
      'select discount_type, result_qty from m_discount_result where discount_id = ? and discount_scheme_id = ?';

  // s_sap_order_dtl
  static String SQL_SAP_ORD_DTL_001 =
      'select *from s_sap_order_dtl where order_id = ?';

  // m_survey
  static String SQL_SUR_001 =
      '''select grp01.*, count(grp02.survey_result_id) as is_complete FROM
          (SELECT
                      tb01.survey_id
                , tb01.survey_code
                , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
                , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
                  FROM
                      m_survey tb01
                  INNER JOIN
                      m_survey_target tb02 ON tb02.survey_id = tb01.survey_id
                  INNER JOIN
                      m_customer tb04 ON tb04.customer_id = tb02.target_id
                  WHERE
                      date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                      AND tb01.status = '01'
                      AND tb02.target_type = '00'
                      AND tb04.customer_id = ?
          UNION
          SELECT
                        tb01.survey_id
                , tb01.survey_code
                , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
                , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
                  FROM
                      m_survey tb01
                  INNER JOIN
                      m_survey_target tb02 ON tb02.survey_id = tb01.survey_id
                  INNER JOIN
                      m_customer_property tb04 ON tb04.customer_property_id = tb02.target_id
                  INNER JOIN
                      m_customer_property_mapping tb05 ON tb05.customer_property_id = tb04.customer_property_id
                  WHERE
                      date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                      AND tb01.status = '01'
                      AND tb02.target_type = '01'
                      AND tb05.customer_id = ?
          UNION
          SELECT
                      tb01.survey_id
                , tb01.survey_code
                , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
                , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
                  FROM
                      m_survey tb01
                  INNER JOIN
                      m_survey_target tb02 ON tb02.survey_id = tb01.survey_id
                  INNER JOIN
                      m_area tb04 ON tb04.area_id = tb02.target_id
                  INNER JOIN
                      m_customer tb05 ON tb05.area_id = tb04.area_id
                  WHERE
                      date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                      AND tb01.status = '01'
                      AND tb02.target_type = '02'
                      AND tb05.customer_id = ?
          UNION
          SELECT
                      tb01.survey_id
                , tb01.survey_code
                , strftime('%d/%m/%Y', substr(tb01.start_date, 1, 10)) as start_date
                , strftime('%d/%m/%Y', substr(tb01.end_date, 1, 10)) as end_date
                  FROM
                      m_survey tb01
                  INNER JOIN
                      m_survey_target tb02 ON tb02.survey_id = tb01.survey_id
                  INNER JOIN
                      m_customers_group tb04 ON tb04.customers_group_id = tb02.target_id
                  INNER JOIN
                      m_customers_group_detail tb05 ON tb05.customers_group_id = tb04.customers_group_id
                  WHERE
                      date('now') BETWEEN date(tb01.start_date) AND date(tb01.end_date)
                      AND tb01.status = '01'
                      AND tb02.target_type = '03'
                      AND tb05.customer_id = ?) grp01
        left join s_survey_result grp02 on grp02.survey_id = grp01.survey_id
                                          and grp02.customer_visit_id = ?
      group by grp01.survey_id,  grp01.survey_code,  grp01.start_date, grp01.end_date
          order by start_date desc''';

  // m_sync_offline
  static String SQL_SYNC_OFF_001 =
      'select *from m_sync_offline where position_id = ? and status = ?';

  static String SQL_STOCK_BALANCE_001 = '''
  WITH product_used_in_order AS
  (SELECT CAST(SUM(od.qty) AS DOUBLE) AS quantity,
          od.product_id
   FROM s_order o
   INNER JOIN s_order_dtl od ON od.order_id = o.order_id
   INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
   WHERE o.horeca_status not in ('01','05')
   AND cs.ba_position_id = ? AND strftime('%Y-%m-%d', o.order_date) = date('now')
   GROUP BY od.product_id),
 product_used_in_promotion AS
  (SELECT CAST(SUM(od.qty) AS DOUBLE) AS quantity,
          od.product_id
   FROM s_order o
   INNER JOIN s_order_promotion_result od ON od.order_id = o.order_id
   INNER JOIN s_customer_visit cs ON cs.customer_visit_id = o.customer_visit_id
   WHERE o.horeca_status not in ('01','05')
   AND cs.ba_position_id = ? AND strftime('%Y-%m-%d', o.order_date) = date('now')
   GROUP BY od.product_id)
SELECT
              tb01.product_id,
              tb01.product_cd,
              tb01.product_name,
              tb01.brand_id,
              tb02.type_name,
              tb03.uom_name,
              IFNULL(grp02.latest_price,0.0) AS price_cost,
              wstockbalance.allocating_stock,
              COALESCE(puio.quantity,0.0) AS order_used_stock,
              COALESCE(puip.quantity,0.0) AS promotion_used_stock
          FROM
            w_stock_balance wstockbalance
          INNER JOIN   m_product tb01 on tb01.product_id = wstockbalance.product_id
                                      and tb01.is_salable = 1
                                      and tb01.status = '01'
          INNER JOIN
              m_product_type tb02 ON tb02.product_type_id = tb01.product_type_id
          INNER JOIN
              m_uom tb03 ON tb03.uom_id = tb01.uom_id
          LEFT JOIN (
              select 
					grp01.customer_id,
                  grp01.product_id,
                  grp01.latest_price,
				  ROW_NUMBER() OVER (PARTITION BY grp01.product_id ORDER BY grp01.updated_date DESC) AS rn
			  from(
				SELECT
                  tb04.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customer tb04 ON tb04.customer_id = tb02.target_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '00'
                  AND tb04.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customer_property tb04 ON tb04.customer_property_id = tb02.target_id
              INNER JOIN
                  m_customer_property_mapping tb05 ON tb05.customer_property_id = tb04.customer_property_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '01'
                  AND tb05.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_area tb04 ON tb04.area_id = tb02.target_id
              INNER JOIN
                  m_customer tb05 ON tb05.area_id = tb04.area_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '02'
                  AND tb05.customer_id = ?
              UNION ALL
              SELECT
                  tb05.customer_id,
                  tb03.product_id,
                  tb03.price AS latest_price,
				  tb03.updated_date
              FROM
                  m_sales_in_price tb01
              INNER JOIN
                  m_sales_in_price_target tb02 ON tb02.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_sales_in_price_dtl tb03 ON tb03.sales_in_price_id = tb01.sales_in_price_id
              INNER JOIN
                  m_customers_group tb04 ON tb04.customers_group_id = tb02.target_id
              INNER JOIN
                  m_customers_group_detail tb05 ON tb05.customers_group_id = tb04.customers_group_id
              WHERE
                  DATE('now') BETWEEN DATE(tb03.start_date) AND DATE(tb03.end_date)
                  AND tb01.status = '01'
                  AND tb02.target_type = '03'
                  AND tb05.customer_id = ?
			  ) grp01
          ) AS grp02 ON tb01.product_id = grp02.product_id AND grp02.rn = 1
		  LEFT JOIN product_used_in_order puio ON puio.product_id = wstockbalance.product_id
		  LEFT JOIN product_used_in_promotion puip ON puip.product_id = wstockbalance.product_id
          WHERE date(wstockbalance.allocate_date) = date('now')
          and wstockbalance.position_id = ?
    ''';

  // m_route_assignment
  static String SQL_ROU_ASS_001 =
      'select *from m_route_assignment where route_id = ?';

  // m_product_branch_mapping
  static String SQL_PRD_BRH_MAP_001 =
      '''select tb03.product_id from m_customer tb01
inner join m_customer_property_mapping tb02 on tb02.customer_id = tb01.customer_id
inner join m_product_branch_mapping tb03 on tb03.branch_id = tb02.customer_property_id
where tb01.customer_id = ?''';

  // s_sap_order_dtl
  static String SQL_SAP_ORD_DEL_001 =
      'select *from s_sap_order_delivery where order_id = ?';

  // m_brand
  static String SQL_BRAND_001 =
      '''select DISTINCT mb.brand_id, mb.brand_cd, mb.brand_name, mb.brand_img from 
        m_brand mb
        inner join m_product mp on mb.brand_id = mp.brand_id
        where mb.status = ?
        order by mp.priority asc''';

  // m_brand
  static String SQL_BRAND_002 = '''SELECT
        DISTINCT mb.brand_id, mb.brand_cd, mb.brand_name, mb.brand_img
    FROM
	w_stock_balance sb
    inner join m_product mp on sb.product_id = mp.product_id
    inner join m_brand mb on mb.brand_id = mp.brand_id
    WHERE
		date(sb.allocate_date) = date('now')
		and sb.position_id = ?
        and mp.is_salable = 1
        and mp.status = ?
		    and mb.status = ?
    ORDER BY  sb.available_stock desc, mp.priority asc''';
}
