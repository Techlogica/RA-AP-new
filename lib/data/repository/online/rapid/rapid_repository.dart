import 'package:flutter/cupertino.dart';
import 'package:rapid_app/data/api/api_client.dart';
import 'package:rapid_app/data/api/http_method.dart';
import 'package:rapid_app/data/model/base/base_response.dart';
import 'package:rapid_app/res/utils/dynamic_default_value_generation/default_concatenator.dart';
import 'package:rapid_app/res/utils/generate_random_string.dart';
import 'package:rapid_app/res/utils/rapid_pref.dart';
import 'package:rapid_app/res/values/strings.dart';

abstract class IRapidRepository {
  /// Getting meta data using the Rapid REST API

  Future<BaseResponse> getMetaData({
    required String projectId,
  });

  Future<BaseResponse> getLoginTable(
      {required String loginTableName,
      required String userNameColumn,
      required String userPasswordColumn,
      required String loginTableIdColumn,
      required String permissionTableName,
      required String permissionTableIdColumn,
      required String metaDataTableIdColumn});

  Future<BaseResponse> getPermissionMenuTable({
    required String metaDataTableIdColumn,
    required String permissionTableName,
    required String permissionTableIdColumn,
    required String prefix,
  });

  Future<BaseResponse> getMetadataColumns({required String sysId});

  Future<BaseResponse> getMenuColumnValues({
    required String tableName,
    required String defaultCondition,
    required int pageNo,
    required String keyInfo,
  });

  Future<BaseResponse> getMenuAllColumnValues({
    required String tableName,
    required String defaultCondition,
  });

  Future<BaseResponse> getChartTabs();

  Future<BaseResponse> getChartDashboard();

  Future<BaseResponse> getChartDashboardPrice({required String query});

  Future<BaseResponse> getCharts();

  Future<BaseResponse> getChartGraph({required String query});

  Future<BaseResponse> getChartGrid({required String query});

  Future<BaseResponse> getQueryDynamicValue({required String query});

  Future<BaseResponse> getCommonSearch({
    required String query,
    required dynamic param,
  });

  Future<BaseResponse> getMenuDetailsSearchFields({required int sysId});
  Future<BaseResponse> getMetadataCommands();

  Future<BaseResponse> getMetadataActions();

  Future<BaseResponse> getLookupData({required String query, String? where});

  Future<BaseResponse> getChild({required int sysId});

  Future<BaseResponse> getChildTable({required int sysId});

  Future<BaseResponse> getMetaDataTableData({required String sysId});

  Future<BaseResponse> getInsertData(
      {required dynamic body, required String tableName});

  Future<BaseResponse> getValidation({required String mdcSysIds});

  Future<BaseResponse> getMtValidationColumns({required String mdcSysIds});

  Future<BaseResponse> getMtValidationButtons({required String mdcSysIds});

  Future<BaseResponse> getDeleteData(
      {required String tableName, required String sysId});

  Future<BaseResponse> getTagBoxData(
      {required String query, String? where, required int pageNo});

  Future<BaseResponse> getTagBoxColumn({int? where});

  Future<BaseResponse> getReportData({required String body});

  Future<BaseResponse> getMenuSingleValues(
      {required String tableName,
      required String sysId,
      required String keyInfo});

  Future<BaseResponse> getTableGroups({
    required String tableId,
  });

  Future<BaseResponse> getGlobalSettingValue({
    required String tableName,
    String? where,
  });

  Future<BaseResponse> getDbProcedure({
    required String query,
    required dynamic param,
  });
}

class RapidRepository extends IRapidRepository {
  RapidRepository(
    this._apiClient,
  );

  final ApiClient _apiClient;

  /// api call
  Future<BaseResponse> getBaseData(query) async {
    // body
    dynamic body = {Strings.kQuery: query};
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeRequest(
      endpoint: Strings.kGetData,
      method: HttpMethod.POST,
      body: body,
      headers: headers,
    );
    return result;
  }

  /// api call with param
  Future<BaseResponse> getBaseDataWithParam(query, param) async {
    // body
    dynamic body = {Strings.kQuery: query};
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeRequestWithParam(
      endpoint: Strings.kGetDataWithParam,
      method: HttpMethod.POST,
      body: body,
      headers: headers,
      param: param,
    );
    return result;
  }

  /// DbProcedure api call with param
  Future<BaseResponse> getDbProcedureData(query, param) async {
    // body
    dynamic body = {Strings.kQuery: query};
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeRequestWithParam(
      endpoint: Strings.kDbProcedure,
      method: HttpMethod.POST,
      body: body,
      headers: headers,
      param: param,
    );
    return result;
  }

  /// insert & update api call
  Future<BaseResponse> insertData(body, tableName) async {
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeInsertDeleteRequest(
      endpoint: tableName,
      method: HttpMethod.POST,
      body: body,
      headers: headers,
    );
    return result;
  }

  /// delete api call
  Future<BaseResponse> deleteData(endPoint) async {
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeInsertDeleteRequest(
      endpoint: endPoint,
      method: HttpMethod.DELETE,
      body: '',
      headers: headers,
    );
    return result;
  }

  /// report api call
  Future<BaseResponse> reportData(body) async {
    // header
    Map<String, String>? headers = {
      Strings.kAuthorization: "${Strings.kBearer} ${RapidPref().getToken()}",
      Strings.kHeaderKey: GetTraceId().generateRandomString(),
    };
    // request and response
    BaseResponse result = await _apiClient.executeInsertDeleteRequest(
      endpoint: Strings.kGetDataReport,
      method: HttpMethod.POST,
      body: body,
      headers: headers,
    );
    return result;
  }

  @override
  Future<BaseResponse> getLoginTable({
    required String loginTableName,
    required String userNameColumn,
    required String userPasswordColumn,
    required String loginTableIdColumn,
    required String permissionTableName,
    required String permissionTableIdColumn,
    required String metaDataTableIdColumn,
  }) async {
    String userTableQuery =
        "SELECT $loginTableIdColumn FROM $loginTableName WHERE"
        " $userNameColumn = '${RapidPref().getUserName().toString()}'";
    final result = await getBaseData(userTableQuery);
    return result;
  }

  @override
  Future<BaseResponse> getMetaData({required String projectId}) async {
    String metadataProjectQuery = 'SELECT MDP_TBL_LOGIN,MDP_LGNFIELD_USERNAME,'
        'MDP_LGNFIELD_PASSWORD,MDP_LGNFIELD_USERID,MDP_TBL_PERMISSION,'
        'MDP_PERMSNFIELD_USERID,MDP_PERMSN_TBLID,MDP_VERSION,MDP_PREFIX,'
        'MDP_GLOBALSETT_ALWAYSHOW,MDP_GLOBAL_TBLID,MDP_PROJ_NAME,MDP_LOGO,'
        'MDP_SIGNUP_TBL,MDP_PERMISSIONID,MDP_MENU_COND,MDP_HEADING '
        'FROM METADATA_PROJECT WHERE MDP_SYS_ID = $projectId';

    final result = await getBaseData(metadataProjectQuery);
    return result;
  }

  @override
  Future<BaseResponse> getPermissionMenuTable({
    required String metaDataTableIdColumn,
    required String permissionTableName,
    required String permissionTableIdColumn,
    required String prefix,
  }) async {
    String insert = prefix + 'INSERT';
    String update = prefix + 'UPDATE';
    String delete = prefix + 'DELETE';
    String menuQuery = '';
    String? menuCondition = RapidPref().getMenuCondition();
    if (menuCondition!.isEmpty) {
      menuQuery = 'SELECT $insert MDT_INSERT,$update MDT_UPDATE,'
          '$delete MDT_DELETE,METADATA_TABLES.*,'
          '${RapidPref().getLoginUserId()} USERID FROM METADATA_TABLES,'
          '$permissionTableName WHERE MDT_SYS_ID=$metaDataTableIdColumn AND '
          '$permissionTableIdColumn = ${RapidPref().getLoginUserId()}';
    } else {
      String? permissionId = RapidPref().getPermissionId();
      menuCondition = await defaultConcatenation(formula: menuCondition);
      menuQuery = 'SELECT $insert MDT_INSERT,$update MDT_UPDATE,'
          '$delete MDT_DELETE,METADATA_TABLES.*,'
          '${RapidPref().getLoginUserId()} USERID FROM METADATA_TABLES,'
          '$permissionTableName WHERE MDT_SYS_ID=$metaDataTableIdColumn AND '
          '$permissionTableIdColumn = ${RapidPref().getLoginUserId()} AND '
          '$permissionId IN ($menuCondition)';
    }
    final result = await getBaseData(menuQuery);
    return result;
  }

  @override
  Future<BaseResponse> getMetadataColumns({required String sysId}) async {
    String columnsQuery =
        'SELECT * FROM METADATA_COLUMNS WHERE MDC_MDT_SYS_ID = ' + sysId;
    final result = await getBaseData(columnsQuery);
    return result;
  }

  @override
  Future<BaseResponse> getMenuColumnValues(
      {required String tableName,
      required String defaultCondition,
      required int pageNo,
      required String keyInfo}) async {
    String columnsQuery;
    if (defaultCondition.isEmpty) {
      columnsQuery = 'SELECT * FROM ' +
          tableName +
          ' ORDER BY ' +
          keyInfo +
          ' DESC OFFSET ' +
          (pageNo - 10).toString() +
          ' rows  fetch next 50 rows only';
    } else {
      columnsQuery = 'SELECT * FROM ' +
          tableName +
          ' WHERE ' +
          defaultCondition +
          ' ORDER BY ' +
          keyInfo +
          ' DESC OFFSET ' +
          (pageNo - 10).toString() +
          ' rows  fetch next 50 rows only';
    }
    final result = await getBaseData(columnsQuery);
    return result;
  }

  @override
  Future<BaseResponse> getMenuAllColumnValues({
    required String tableName,
    required String defaultCondition,
  }) async {
    String columnsQuery;
    if (defaultCondition.isEmpty) {
      columnsQuery = "SELECT * FROM $tableName ";
    } else {
      columnsQuery = "SELECT * FROM $tableName WHERE $defaultCondition ";
    }
    final result = await getBaseData(columnsQuery);
    return result;
  }

  @override
  Future<BaseResponse> getChartTabs() async {
    String columnsQuery = '';
    String companyGlobalValue = RapidPref().getGlobalSettingValue().toString();
    if (companyGlobalValue != '' && companyGlobalValue != 'null') {
      columnsQuery = "SELECT * FROM CHART_GROUP WHERE CG_SYS_ID IN "
          "(SELECT C_CG_GROUP_ID FROM CHARTS WHERE C_SYS_ID IN "
          "(SELECT CU_C_CHART_ID FROM CHART_USER WHERE "
          "CU_MTL_USRID = ${RapidPref().getLoginUserId()} "
          "INTERSECT "
          "SELECT CC_C_SYS_ID FROM CHART_COMP WHERE "
          "CC_COMP_CODE = '$companyGlobalValue') AND "
          "C_MDP_SYS_ID = ${RapidPref().getProjectId()}) "
          "UNION "
          "SELECT * FROM CHART_GROUP WHERE CG_SYS_ID IN "
          "(SELECT MTDU_CG_SYS_ID FROM MT_DASHBOARD_USER WHERE "
          "MTDU_MTL_USER_ID = ${RapidPref().getLoginUserId()} AND "
          "MTDU_MTD_DASH_ID IN "
          "(SELECT MTD_SYS_ID FROM MT_DASHBOARD WHERE "
          "MTD_MDP_SYS_ID = ${RapidPref().getProjectId()}))";
    } else {
      columnsQuery = 'SELECT * FROM CHART_GROUP WHERE CG_SYS_ID IN '
          '(SELECT C_CG_GROUP_ID FROM CHARTS WHERE C_SYS_ID IN '
          '(SELECT CU_C_CHART_ID FROM CHART_USER WHERE '
          'CU_MTL_USRID = ${RapidPref().getLoginUserId()}) AND '
          'C_MDP_SYS_ID = ${RapidPref().getProjectId()}) UNION '
          'SELECT * FROM CHART_GROUP WHERE CG_SYS_ID IN '
          '(SELECT MTDU_CG_SYS_ID FROM MT_DASHBOARD_USER WHERE '
          'MTDU_MTL_USER_ID = ${RapidPref().getLoginUserId()} AND '
          'MTDU_MTD_DASH_ID IN (SELECT MTD_SYS_ID FROM MT_DASHBOARD WHERE '
          'MTD_MDP_SYS_ID = ${RapidPref().getProjectId()}))';
    }

    final result = await getBaseData(columnsQuery);
    return result;
  }

  @override
  Future<BaseResponse> getChartDashboard() async {
    String columnsQuery = 'SELECT * FROM MT_DASHBOARD,MT_DASHBOARD_USER '
            'WHERE MTD_SYS_ID=MTDU_MTD_DASH_ID AND MTDU_MTL_USER_ID=' +
        RapidPref().getLoginUserId().toString() +
        ' AND MTD_MDP_SYS_ID =' +
        RapidPref().getProjectId().toString();
    final result = await getBaseData(columnsQuery);
    return result;
  }

  @override
  Future<BaseResponse> getChartDashboardPrice({
    required String? query,
  }) async {
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getCharts() async {
    String chartQuery = '';
    String companyGlobalValue = RapidPref().getGlobalSettingValue().toString();
    if (companyGlobalValue != '' && companyGlobalValue != 'null') {
      chartQuery = "SELECT * FROM CHARTS,CHART_USER,CHART_AXES WHERE "
          "CA_C_CHART_ID = CU_C_CHART_ID AND CHART_AXES.CA_C_CHART_ID=C_SYS_ID"
          " AND CU_MTL_USRID= ${RapidPref().getLoginUserId().toString()} "
          "AND C_MDP_SYS_ID = ${RapidPref().getProjectId().toString()} "
          "AND C_SYS_ID IN "
          "(SELECT CC_C_SYS_ID FROM CHART_COMP WHERE "
          "CC_COMP_CODE = '$companyGlobalValue')";
    } else {
      chartQuery = 'SELECT * FROM CHARTS,CHART_USER,CHART_AXES WHERE '
          'CA_C_CHART_ID = CU_C_CHART_ID AND CHART_AXES.CA_C_CHART_ID=C_SYS_ID '
          'AND CU_MTL_USRID= ${RapidPref().getLoginUserId().toString()}  AND '
          'C_MDP_SYS_ID = ${RapidPref().getProjectId().toString()}';
    }
    final result = await getBaseData(chartQuery);
    return result;
  }

  @override
  Future<BaseResponse> getChartGraph({required String query}) async {
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getChartGrid({required String query}) async {
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getQueryDynamicValue({required String query}) async {
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getCommonSearch({
    required String query,
    required dynamic param,
  }) async {
    return await getBaseDataWithParam(query, param);
  }

  @override
  Future<BaseResponse> getMenuDetailsSearchFields({required int sysId}) async {
    String query =
        "SELECT * FROM METADATA_COLUMNS WHERE MDC_MDT_SYS_ID = $sysId";
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getMetadataCommands() async {
    String query = 'SELECT * FROM METADATA_COMMANDS';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getMetadataActions() async {
    String query = 'SELECT * FROM METADATA_ACTIONS';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getLookupData({required String query, String? where})
  async {
    String queryIp = query;
    if (where!.isNotEmpty) {
      queryIp = '$query WHERE $where';
      // debugPrint(".............queryq $queryIp");
    }
    return await getBaseData(queryIp);
  }

  @override
  Future<BaseResponse> getChildTable({required int sysId}) async {
    String tableId = RapidPref().getMdpPermissionTblId().toString();
    String tablePermission = RapidPref().getMdpTblPermission().toString();
    String prefix = RapidPref().getMdpPermissionPrefix().toString();
    String userId = RapidPref().getLoginUserId().toString();
    String fieldUserId = RapidPref().getMdpPermissionFldUsrid().toString();

    String insert = prefix + 'INSERT';
    String update = prefix + 'UPDATE';
    String delete = prefix + 'DELETE';
    String query = 'SELECT MDT_SYS_ID,MDT_TBL_NAME,MDT_TBL_TITLE,'
        'MDT_CHILDWHERE,MDT_CHILD_ISBTN, $insert MDT_INSERT,$update MDT_UPDATE,'
        '$delete MDT_DELETE,MDT_CHILDROW_COND FROM METADATA_TABLES,'
        '$tablePermission WHERE MDT_SYS_ID=$tableId AND MDT_SYS_ID IN(SELECT '
        'MDCT_CHLD_TBLID FROM METADATA_CHILDTABLES WHERE MDCT_MDT_SYS_ID = '
        '$sysId) AND $fieldUserId = $userId';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getChild({required int sysId}) async {
    String tableId = RapidPref().getMdpPermissionTblId().toString();
    String tablePermission = RapidPref().getMdpTblPermission().toString();
    String prefix = RapidPref().getMdpPermissionPrefix().toString();
    String userId = RapidPref().getLoginUserId().toString();
    String fieldUserId = RapidPref().getMdpPermissionFldUsrid().toString();

    String insert = prefix + 'INSERT';
    String update = prefix + 'UPDATE';
    String delete = prefix + 'DELETE';
    String query = 'SELECT MDT_SYS_ID,MDT_TBL_NAME,MDT_TBL_TITLE,'
        'MDT_CHILDWHERE,MDT_CHILD_ISBTN, $insert MDT_INSERT,$update MDT_UPDATE,'
        '$delete MDT_DELETE,MDT_CHILDROW_COND FROM METADATA_TABLES,'
        '$tablePermission WHERE MDT_SYS_ID=$tableId AND MDT_SYS_ID IN (SELECT '
        'MDT_TBL_CHILDID FROM METADATA_TABLES WHERE MDT_SYS_ID = $sysId) AND '
        '$fieldUserId = $userId';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getMetaDataTableData({required String sysId}) async {
    String query = 'SELECT METADATA_TABLES.*,${RapidPref().getLoginUserId()} '
        'USERID FROM METADATA_TABLES WHERE MDT_SYS_ID = $sysId';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getInsertData(
      {required body, required String tableName}) async {
    return await insertData(body, tableName);
  }

  @override
  Future<BaseResponse> getValidation({required String mdcSysIds}) async {
    String query = 'SELECT * FROM METADATA_VALIDATIONS WHERE MDV_MDC_SYS_ID IN '
        '($mdcSysIds)';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getMtValidationColumns(
      {required String mdcSysIds}) async {
    String query = 'SELECT * FROM MT_DATA_VALIDATION WHERE MTDV_VAL_COLUMNID IN'
        '($mdcSysIds)';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getMtValidationButtons(
      {required String mdcSysIds}) async {
    String query = 'SELECT * FROM MT_DATA_VALIDATION WHERE MTDV_VAL_BTNID IN '
        '($mdcSysIds)';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getDeleteData(
      {required String tableName, required String sysId}) async {
    String endPoint = '$tableName/$sysId';
    return await deleteData(endPoint);
  }

  @override
  Future<BaseResponse> getTagBoxData({required String query, String? where, required int pageNo}) async {
    String queryIp = query;
    if (where!.isNotEmpty) {
      queryIp = '$query WHERE $where';
      debugPrint("...........gettagbox$queryIp");
    }
    return await getBaseData(queryIp +
        ' OFFSET ' +
        (pageNo - 10).toString() +
        ' rows  fetch next 50 rows only');
  }

  @override
  Future<BaseResponse> getTagBoxColumn({int? where}) async {
    String query = 'SELECT MC_DISPLAY_COLUMNS,MC_SEQ_NO,MC_DATATYPE,MC_VALUES,MC_BINDFIELDS,MC_BINDVALUES FROM METADATA_COMBOCOLUMN';
    if (where != null) {
      query = '$query WHERE MC_MDC_COLUMN_ID = $where';
      debugPrint("...................query$query");
    }
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getReportData({required String body}) async {
    return await reportData(body);
  }

  @override
  Future<BaseResponse> getMenuSingleValues(
      {required String tableName,
      required String sysId,
      required String keyInfo}) async {
    String singleQuery;
    singleQuery = "SELECT * FROM $tableName WHERE $keyInfo = '$sysId'";
    final result = await getBaseData(singleQuery);
    return result;
  }

  @override
  Future<BaseResponse> getTableGroups({required String tableId}) async {
    String query =
        'SELECT * FROM METADATA_TABLEGROUPS WHERE MTG_MDT_SYS_ID = $tableId '
        'ORDER BY MTG_SYS_ID ASC';
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getGlobalSettingValue({
    required String tableName,
    String? where,
  }) async {
    String query = 'SELECT * FROM $tableName';
    if (where!.isNotEmpty) {
      query = query + ' WHERE $where';
    }
    return await getBaseData(query);
  }

  @override
  Future<BaseResponse> getDbProcedure({required String query, required param}) {
    return getDbProcedureData(query, param);
  }
}
