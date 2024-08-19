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
        let mainInfo: Driver<MainInfoModel>
        let companyInfo: Driver<CompanyInfoModel>
        let summaryInfo: Driver<SummaryInfoModel>
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
        
        let mainInfo = jobDetail.map {
            MainInfoModel(
                dDay: $0.dDay,
                title: $0.title,
                deadline: $0.deadline,
                workingPeriod: $0.workingPeriod,
                startDate: $0.startDate,
                viewCount: $0.viewCount
            )
        }.asDriver(
            onErrorJustReturn: MainInfoModel(
                dDay: "",
                title: "",
                deadline: "",
                workingPeriod: "",
                startDate: "",
                viewCount: 0
            )
        )
        
        let companyInfo = jobDetail.map {
            CompanyInfoModel(
                company: $0.company,
                companyCategory: $0.companyCategory,
                companyImage: $0.companyImage
            )
        }.asDriver(
            onErrorJustReturn: CompanyInfoModel(
                company: "",
                companyCategory: "",
                companyImage: nil
            )
        )
        
        let summaryInfo = jobDetail.map {
            SummaryInfoModel(
                qualification: $0.qualification.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) },
                jobType: $0.jobType.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            )
        }.asDriver(
            onErrorJustReturn: SummaryInfoModel(
                qualification: [],
                jobType: []
            )
        )
        
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
            mainInfo: mainInfo,
            companyInfo: companyInfo,
            summaryInfo: summaryInfo,
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
