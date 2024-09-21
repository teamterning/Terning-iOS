//
//  JobDetailViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class JobDetailViewModel: ViewModelType {
    
    // MARK: - Properties
    
    private let announcementsProvider = Providers.announcementsProvider
    private let jobDetailRepository: JobDetailRepositoryInterface
    
    // MARK: - Input
    
    struct Input {
        let internshipAnnouncementId: BehaviorRelay<Int> 
        let fetchJobDetail: Observable<Void>
        let addScrapTrigger: Observable<(Int, String)>
        let cancelScrapTrigger: Observable<Int>
    }
    
    // MARK: - Output
    
    struct Output {
        let jobDetailInfo: Driver<JobDetailModel>
        let companyInfo: Driver<CompanyInfoModel>
        let mainInfo: Driver<MainInfoModel>
        let summaryInfo: Driver<SummaryInfoModel>
        let conditionInfo: Driver<ConditionInfoModel>
        let detailInfo: Driver<DetailInfoModel>
        let bottomInfo: Driver<BottomInfoModel>
        let error: Driver<String>
        let successMessage: Driver<String>
        let addScrapResult: Driver<Void>
        let cancelScrapResult: Driver<Void>
    }
    
    // MARK: - Init
    
    init(jobDetailRepository: JobDetailRepositoryInterface) {
        self.jobDetailRepository = jobDetailRepository
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let errorTracker = PublishSubject<String>()
        let successMessageTracker = PublishSubject<String>()
        
        let jobDetail = input.internshipAnnouncementId
            .flatMapLatest { id in
                input.fetchJobDetail
                    .flatMapLatest { _ in
                        self.fetchJobDetailFromServer(internshipAnnouncementId: id)
                            .asDriver(onErrorJustReturn: JobDetailModel(
                                companyImage: "",
                                dDay: "",
                                title: "",
                                workingPeriod: "",
                                isScrapped: false,
                                color: "red",
                                deadline: "",
                                startYearMonth: "",
                                scrapCount: 0,
                                viewCount: 0,
                                company: "",
                                companyCategory: "",
                                qualification: "",
                                jobType: "",
                                detail: "",
                                url: ""
                            ))
                    }
            }
            .share(replay: 1)
        
        let jobDetailInfo = jobDetail.map {
            JobDetailModel(
                companyImage: $0.companyImage,
                dDay: $0.dDay,
                title: $0.title,
                workingPeriod: $0.workingPeriod,
                isScrapped: $0.isScrapped,
                color: $0.color,
                deadline: $0.deadline,
                startYearMonth: $0.startYearMonth,
                scrapCount: $0.scrapCount,
                viewCount: $0.viewCount,
                company: $0.company,
                companyCategory: $0.companyCategory,
                qualification: $0.qualification,
                jobType: $0.jobType,
                detail: $0.detail,
                url: $0.url
            )
        }.asDriver(
            onErrorJustReturn: JobDetailModel(
                companyImage: "",
                dDay: "",
                title: "",
                workingPeriod: "",
                isScrapped: false,
                color: "red",
                deadline: "",
                startYearMonth: "",
                scrapCount: 0,
                viewCount: 0,
                company: "",
                companyCategory: "",
                qualification: "",
                jobType: "",
                detail: "",
                url: ""
            )
        )
        
        let companyInfo = jobDetail.map {
            CompanyInfoModel(
                companyImage: $0.companyImage,
                company: $0.company,
                companyCategory: $0.companyCategory
            )
        }.asDriver(
            onErrorJustReturn: CompanyInfoModel(
                companyImage: nil,
                company: "",
                companyCategory: ""
            )
        )
        
        let mainInfo = jobDetail.map {
            MainInfoModel(
                dDay: $0.dDay,
                title: $0.title,
                viewCount: $0.viewCount
            )
        }.asDriver(
            onErrorJustReturn: MainInfoModel(
                dDay: "",
                title: "",
                viewCount: 0
            )
        )
        
        let summaryInfo = jobDetail.map {
            SummaryInfoModel(items: [
                InfoItem(title: "서류 마감", description: $0.deadline),
                InfoItem(title: "근무 기간", description: $0.workingPeriod),
                InfoItem(title: "근무 시작", description: $0.startYearMonth)
            ])
        }.asDriver(onErrorJustReturn: SummaryInfoModel(items: []))
        
        let conditionInfo = jobDetail.map {
            ConditionInfoModel(items: [
                InfoItem(title: "모집대상", description: $0.qualification),
                InfoItem(title: "모집직무", description: $0.jobType)
            ])
        }.asDriver(onErrorJustReturn: ConditionInfoModel(items: []))
        
        let detailInfo = jobDetail.map {
            DetailInfoModel(
                detail: $0.detail
            )
        }.asDriver(
            onErrorJustReturn: DetailInfoModel(
                detail: ""
            )
        )
        
        let bottomInfo = jobDetail.map {
            BottomInfoModel(
                url: $0.url,
                isScrapped: $0.isScrapped,
                scrapCount: $0.scrapCount
            )
        }.asDriver(
            onErrorJustReturn: BottomInfoModel(
                url: "",
                isScrapped: false,
                scrapCount: 0
            )
        )
        
        let addScrap = input.addScrapTrigger
            .flatMapLatest { (intershipAnnouncementId, color) in
                self.jobDetailRepository.addScrap(internshipAnnouncementId: intershipAnnouncementId, color: color)
                    .do(onNext: {
                        successMessageTracker.onNext("스크랩 완료!")
                    })
                    .catch { error in
                        errorTracker.onNext("스크랩 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let cancelScrap = input.cancelScrapTrigger
            .flatMapLatest { intershipAnnouncementId in
                
                self.jobDetailRepository.cancelScrap(internshipAnnouncementId: intershipAnnouncementId)
                    .do(onNext: {
                        successMessageTracker.onNext("관심 공고가 캘린더에서 사라졌어요!")
                    })
                    .catch { error in
                        errorTracker.onNext("스크랩 취소 오류: \(error.localizedDescription)")
                        return .empty()
                    }
            }
            .asDriver(onErrorDriveWith: .empty())
        
        let error = errorTracker.asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")
        let successMessage = successMessageTracker.asDriver(onErrorJustReturn: "")
        
        return Output(
            jobDetailInfo: jobDetailInfo,
            companyInfo: companyInfo,
            mainInfo: mainInfo,
            summaryInfo: summaryInfo,
            conditionInfo: conditionInfo,
            detailInfo: detailInfo,
            bottomInfo: bottomInfo,
            error: error,
            successMessage: successMessage,
            addScrapResult: addScrap,
            cancelScrapResult: cancelScrap
        )
    }
}

// MARK: - Methods
extension JobDetailViewModel {
    private func fetchJobDetailFromServer(internshipAnnouncementId: Int) -> Observable<JobDetailModel> {
        return Observable.create { observer in
            let request = self.announcementsProvider.request(.getAnnouncements(internshipAnnouncementId: internshipAnnouncementId)) { result in
                switch result {
                case .success(let response):
                    let status = response.statusCode
                    if 200..<300 ~= status {
                        do {
                            let responseDto = try response.map(BaseResponse<JobDetailModel>.self)
                            if let data = responseDto.result {
                                observer.onNext(data)
                                observer.onCompleted()
                            } else {
                                print("no data")
                                observer.onError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"]))
                            }
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(error)
                        }
                    } else if status >= 400 {
                        print("400 error")
                        observer.onError(NSError(domain: "", code: status, userInfo: [NSLocalizedDescriptionKey: "Error with status code: \(status)"]))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
