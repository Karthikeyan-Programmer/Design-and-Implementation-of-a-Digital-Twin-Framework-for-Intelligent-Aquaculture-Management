classdef CustomImageDatastore < matlab.io.Datastore
    properties
        ImageDatastore
        Labels
        CurrentIndex
        NumObservations
    end
    
    methods
        function ds = CustomImageDatastore(imageDatastore, labels)
            ds.ImageDatastore = imageDatastore;
            ds.Labels = labels;
            ds.NumObservations = numel(labels);
            ds.CurrentIndex = 0;
        end
        
        function [data, info] = read(ds)
            if ~hasdata(ds)
                reset(ds);
                error('No more data available');
            end
            
            ds.CurrentIndex = ds.CurrentIndex + 1;
            
            % Read image and label
            [img, info] = read(ds.ImageDatastore);
            % Get corresponding label
            index = ds.CurrentIndex;
            label = ds.Labels(index);
            data = {img, label};
        end
        
        function reset(ds)
            reset(ds.ImageDatastore);
            ds.CurrentIndex = 0;
        end
        
        function tf = hasdata(ds)
            tf = ds.CurrentIndex < ds.NumObservations;
        end
        
        function num = numObservations(ds)
            num = ds.NumObservations;
        end
        
        function data = readall(ds)
            data = cell(ds.NumObservations, 2);
            for i = 1:ds.NumObservations
                [img, ~] = read(ds);
                data{i, 1} = img;
                data{i, 2} = ds.Labels(i);
            end
        end
        
        function output = preview(ds)
            [img, label] = read(ds);
            output = {img, label};
        end
    end
end
