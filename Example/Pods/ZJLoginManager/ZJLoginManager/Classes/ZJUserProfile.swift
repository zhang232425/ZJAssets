//
//  ZJUserProfile.swift
//  Pods-ZJLoginManager_Example
//
//  Created by Jercan on 2023/9/11.
//

import HandyJSON

public enum RMType: Int, HandyJSONEnum {
    case RM
    case BA
}

public enum RMStatus: Int, HandyJSONEnum {
    case close
    case open
}

/// 1.初始态， 2.认证通过， 3.被拒绝，4.冻结，5.审核中
public enum CertificationStatus: Int, HandyJSONEnum {
    /// 未认证
    case unAuth = 1
    /// 通过
    case pass
    /// 被拒绝
    case rejected
    /// 冻结
    case frozen
    /// 审核中
    case processing
}

public enum FundStatus: Int, HandyJSONEnum {
    /// 未开户
    case unOpen = 0
    /// 激活
    case open
    /// 冻结
    case frozen
    /// 关闭
    case close
}

public enum FundOpenAccountStatus: Int, HandyJSONEnum {
    /// 未开户，未提交资料
    case accountUnOpen = 0
    /// 审核中
    case processing = 5
    /// 开户中
    case opening = 10
    /// 开户成功
    case opened  = 20
    /// 开户失败
    case rejected = 30
}

public enum RiskAppraisalType: Int, HandyJSONEnum {
    /// 未评估
    case unAssess = 0
    /// 保守型
    case keep     = 1
    /// 稳健型
    case steady   = 2
    /// 平稳型
    case balance  = 4
    /// 成长型
    case growup   = 8
    /// 进取型
    case advance  = 16
}

/// 税号状态
public enum TaxIdStatus: Int, HandyJSONEnum {
    /// 未开户，未提交
    case waitingSubmit = 0
    /// 审核中
    case processing
    /// 已审核
    case reviewed
    /// 无效
    case invalid
}

/// 注销显示开关 0-关，1-开
public enum DestroySwitchStatus: Int, HandyJSONEnum {
    /// 关
    case close
    /// 开
    case open
}

/// 是否注销过 0-否 1-是
public enum DestroyStatus: Int, HandyJSONEnum {
    /// 否
    case none
    /// 是
    case yet
}

/// 认证是否有效 0-否，1-是
public enum ActiveStatus: Int, HandyJSONEnum {
    /// 否
    case none
    /// 是
    case yet
}


open class ZJUserProfile {
    
    /// 身份证类型
    public var idType = ""
    /// 证件号码
    public var IDNumber = ""
    /// 头像
    public var avatarUrl = ""
    /// 用户名
    public var userName = ""
    /// 手机号码
    public var phoneNumber = ""
    /// 是否设置支付密码
    public var isSetPayPassword = false
    /// 用户id
    public var userId = ""
    /// 未读优惠券数
    public var newCouponCount = ""
    /// 编码名字
    public var rmName = ""
    /// RM/BA编码
    public var rmCode = ""
    /// RM/BA 编码 的 id
    public var rmId = ""
    /// 编码类型
    public var rmType: RMType?
    /// 编码状态
    public var rmStatus: RMStatus?
    /// 入驻天数
    public var rmTime = ""
    /// 是否设置了手势密码
    public var isSetGesture = false
    /// 实名认证状态
    public var status = CertificationStatus.unAuth
    
    public var bankIcon = ""
    
    public var bankAccount = ""
    
    public var bankName = ""
    
    public var bankHoldName = ""
    /// 我的邀请码
    public var referrerCode = ""
    
    public var isInvested = false
    /// 投资次数
    public var investTimes = 0
    
    public var isFrozen = false
    
    public var isAlertFrozen = false
    /// 当前等级
    public var level = 0
    /// 当前经验值
    public var point = 0
    /// 下一级经验值
    public var maxPoint = 0
    /// 未领取等级奖励数
    public var unReceiveCount = 0
    /// 待完成任务的奖励金额
    public var unFinishTaskReward = ""
    /// 会员等级
    public var membershipLevel = ""
    /// 当前财富值
    public var currentWealth = ""
    /// 当前会员等级的最高财富值
    public var highestWealthOfCurrentLevel = ""
    /// 会员等级对应的个人中心背景图地址
    public var backgroundImage = ""
    
    /// 会员等级标题
    public var memberLevelTitle = ""
    
    /// 会员等级详细描述
    public var memberLevelDesc = ""
    
    /// 邮箱
    public var email = ""
    
    public var phoneEncrypt = ""
    
    public var IDNumberEncrypt = ""
    
    /// 昵称
    public var nickname = ""
    
    ///基金账户状态
    public var fundAccountStatus = FundStatus.unOpen
    ///基金开户状态
    public var fundOpenAccountStatus : FundOpenAccountStatus?

    /// 风险评测类型
    public var riskAppraisalType = RiskAppraisalType.unAssess
    /// 风险评测类型文本
    public var riskAppraisalTypeTitle = ""
    /// 基金开户状态文本
    public var fundOpenAccountStatusTitle = ""
    /// 基金开户成功sid
    public var sid = ""
    /// 基金开户成功ifua
    public var ifua = ""
    ///控制个人信息，风险测评和开户信息是否显示 (是否开启风险测评(0=否,1=是))
    public var enableRiskAppraisal = 0
    /// 税号状态
    public var taxIdStatus: TaxIdStatus = .waitingSubmit
    /// 税号状态文本
    public var taxIdStatusTitle = ""
    /// 税号
    public var companyTaxNo = ""
    
    /// 注销显示开关
    public var destroySwitch: DestroySwitchStatus = .close
    /// 是否注销过
    public var isDestroy: DestroyStatus = .none
    
    /// 认证是否有效(默认有效)
    public var activeStatus: ActiveStatus = .yet
    

    required public init() {}
    
}

extension ZJUserProfile: HandyJSON {
    
    public func mapping(mapper: HelpingMapper) {
        
        mapper <<< userId           <-- "uid"
        
        mapper <<< bankIcon         <-- "bankImage"
        
        mapper <<< userName         <-- "fullName"
        
        mapper <<< avatarUrl        <-- "avatar"
        
        mapper <<< isInvested       <-- "invite"
        
        mapper <<< isFrozen         <-- "frozenStatus"
        
        mapper <<< isSetGesture     <-- "gesture"
        
        mapper <<< isSetPayPassword <-- "isSetPaymentPwd"
        
        mapper <<< isAlertFrozen    <-- "frozenTimes"
        
        mapper <<< IDNumber         <-- "identification"
        
        mapper <<< newCouponCount   <-- "newCouponNum"
        
        mapper <<< phoneNumber      <-- "phoneNum"
        
        mapper <<< phoneEncrypt     <-- "phoneNumEncrypt"
        
        mapper <<< IDNumberEncrypt  <-- "identificationEncrypt"
        
        mapper <<< memberLevelTitle <-- "membershipLevelDes"
        
        mapper <<< memberLevelDesc  <-- "membershipLevelPrivilegeDes"
        
        mapper <<< nickname         <-- "nickName"
        
    }
    
}
