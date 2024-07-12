//
//  JobDetailViewModel.swift
//  Terning-iOS
//
//  Created by 정민지 on 7/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class JobDetailViewModel {
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    struct Input {
        let fetchJobDetail: Observable<Void>
    }
    
    // MARK: - Output
    
    struct Output {
        let mainInfo: Driver<MainInfoModel>
        let companyInfo: Driver<CompanyInfoModel>
        let summaryInfo: Driver<SummaryInfoModel>
        let detailInfo: Driver<DetailInfoModel>
        let bottomInfo: Driver<BottomInfoModel>
    }
    
    // MARK: - Transform
    
    func transform(_ input: Input) -> Output {
        let jobDetail = input.fetchJobDetail
            .flatMapLatest { _ in
                self.fetchJobDetailFromServer()
                    .asDriver(onErrorJustReturn: JobDetailModel(
                        dDay: "",
                        title: "",
                        deadline: "",
                        workingPeriod: "",
                        startDate: "",
                        viewCount: 0,
                        company: "",
                        companyCategory: "",
                        companyImage: "",
                        qualification: "",
                        jobType: "",
                        detail: "",
                        url: "",
                        isScrap: false,
                        scrapCount: 500
                    ))
            }
            .share(replay: 1)
        
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
                isScrap: $0.isScrap,
                scrapCount: $0.scrapCount
            )
        }.asDriver(
            onErrorJustReturn: BottomInfoModel(
                url: "",
                isScrap: false,
                scrapCount: 0
            )
        )
        
        return Output(
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
    
    private func fetchJobDetailFromServer() -> Observable<JobDetailModel> {
        let dummyData = JobDetailModel(
            dDay: "D-4",
            title: "[SomeOne] 성공성공성공성공",
            deadline: "2024년 7월 23일",
            workingPeriod: "2개월",
            startDate: "2024년 8월",
            viewCount: 3423,
            company: "모니모니",
            companyCategory: "스타트업",
            companyImage: "https://images.unsplash.com/photo-1573865526739-10659fec78a5?q=80&w=2815&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
            qualification: "졸업 예정자, 휴학생 가능, 헐, ㅋ",
            jobType: "그래픽 디자인, UX/UI/GUI 디자인, 대박, ㅋㅋ",
            detail: "모니모니의 마케팅 팀은 소비자에게 삶의 솔루션으로서 ‘사랑’을 제시하는 아주 멋진 팀입니다.\n‘사랑’의 가치를 전 세계에 전파하기 위해 마케터는 그 누구보다 넓은 시야를 가져야 합니다. 거시적인 관점과 미시적인 관점을 모두 포괄할 수 있는 통찰력을 바탕으로 나아갑니다.\n데이터에 근거하여 소통합니다. ‘사랑’,  ‘행복’. ‘같이’와 같은 추상적인 가치들을 수치로 가시화하는 아주 재미있는 작업을 함께합니다.",
            url: "https://github.com/teamterning",
            isScrap: true,
            scrapCount: 3423
        )
        return Observable.just(dummyData)
    }
}
