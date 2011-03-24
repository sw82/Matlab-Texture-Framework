groups = ismember(name,'Blatt');         %# create a two-class problem

cvFolds = crossvalind('Kfold', groups, 10);  %# get indices of 10-fold CV
cp = classperf(groups);                      %# init performance tracker

for i = 1:10                                 %# for each fold
    testIdx = (cvFolds == i);                %# get indices of test instances
    trainIdx = ~testIdx;                     %# get indices training instances

    %# train an SVM model over training instances
    svmModel = svmtrain(values(trainIdx,1:2), groups(trainIdx), ...
                 'Autoscale',true, 'Showplot',false, 'Method','QP', ...
                 'BoxConstraint',2e-1, 'Kernel_Function','mlp');

    %# test using test instances
    pred = svmclassify(svmModel, values(testIdx,:), 'Showplot',false);

    %# evaluate and update performance object
    cp = classperf(cp, pred, testIdx);
end

%# get accuracy
cp.CorrectRate

%# get confusion matrix
%# columns:actual, rows:predicted, last-row: unclassified instances
cp.CountingMatrix