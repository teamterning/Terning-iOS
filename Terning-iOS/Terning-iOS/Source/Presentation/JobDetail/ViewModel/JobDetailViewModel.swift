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
    
    // MARK: - Input
    
    struct Input {
        let internshipAnnouncementId: Observable<Int>
        let fetchJobDetail: Observable<Void>
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
    }
    
    // MARK: - Transform
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let jobDetail = input.internshipAnnouncementId
            .flatMapLatest { id in
                input.fetchJobDetail
                    .flatMapLatest { _ in
                        self.fetchJobDetailFromServer(internshipAnnouncementId: id)
                            .asDriver(onErrorJustReturn: JobDetailModel(
                                dDay: "",
                                title: "",
                                deadline: "",
                                workingPeriod: "",
                                startDate: "",
                                scrapCount: 0,
                                viewCount: 0,
                                company: "",
                                companyCategory: "",
                                companyImage: "",
                                qualification: "",
                                jobType: "",
                                detail: "",
                                url: "",
                                scrapId: nil
                            ))
                    }
            }
            .share(replay: 1)
        
        let jobDetailInfo = jobDetail.map {
            JobDetailModel(
                dDay: $0.dDay,
                title: $0.title,
                deadline: $0.deadline,
                workingPeriod: $0.workingPeriod,
                startDate: $0.startDate,
                scrapCount: $0.scrapCount,
                viewCount: $0.viewCount,
                company: $0.company,
                companyCategory: $0.companyCategory,
                companyImage: $0.companyImage,
                qualification: $0.qualification,
                jobType: $0.jobType,
                detail: $0.detail,
                url: $0.url,
                scrapId: $0.scrapId
            )
        }.asDriver(
            onErrorJustReturn: JobDetailModel(
                dDay: "",
                title: "",
                deadline: "",
                workingPeriod: "",
                startDate: "",
                scrapCount: 0,
                viewCount: 0,
                company: "",
                companyCategory: "",
                companyImage: "",
                qualification: "",
                jobType: "",
                detail: "",
                url: "",
                scrapId: nil
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
                InfoItem(title: "근무 시작", description: $0.startDate)
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
                scrapId: $0.scrapId,
                scrapCount: $0.scrapCount
            )
        }.asDriver(
            onErrorJustReturn: BottomInfoModel(
                url: "",
                scrapId: nil,
                scrapCount: 0
            )
        )
        
        return Output(
            jobDetailInfo: jobDetailInfo,
            companyInfo: companyInfo,
            mainInfo: mainInfo,
            summaryInfo: summaryInfo,
            conditionInfo: conditionInfo,
            detailInfo: detailInfo,
            bottomInfo: bottomInfo
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
