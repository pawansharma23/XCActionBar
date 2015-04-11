//
//  XCActionBarPresetStateController.m
//  XCActionBar
//
//  Created by Pedro Gomes on 10/04/2015.
//  Copyright (c) 2015 Pedro Gomes. All rights reserved.
//

#import "XCActionBarCommandProcessor.h"
#import "XCActionBarPresetCommandHandler.h"
#import "XCActionInterface.h"
#import "XCActionPreset.h"

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@interface XCActionBarPresetCommandHandler ()

@property (nonatomic, copy) NSString *searchExpression;

@property (nonatomic, weak) id<XCActionBarCommandProcessor> commandProcessor;
@property (nonatomic, weak) NSTextField *inputField;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
@implementation XCActionBarPresetCommandHandler

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (instancetype)initWithCommandProcessor:(id<XCActionBarCommandProcessor>)processor
{
    if((self = [super init])) {
        self.commandProcessor = processor;
    }
    return self;
}

#pragma mark - XCActionBarCommandHandler

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)enterWithInputControl:(NSTextField *)field
{
    self.inputField = field;
    
    id delegate = self.inputField.delegate;
    self.inputField.delegate = nil;
    
    self.inputField.stringValue       = (self.searchExpression ?: @"");
    self.inputField.placeholderString = NSLocalizedString(@"Choose a preset ...", @"");
    
    self.inputField.delegate = delegate;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (void)exit
{
    
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleCursorUpCommand
{
    return [self.commandProcessor selectPreviousSearchResult];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleCursorDownCommand
{
    return [self.commandProcessor selectNextSearchResult];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleDoubleClickCommand
{
    return [self.commandProcessor executeSelectedAction];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleEnterCommand
{
    id<XCActionPreset> selectedPreset = [self.commandProcessor retrieveSelectedPreset];
    XCReturnFalseUnless(selectedPreset != nil);
    
    return [self.commandProcessor executeActionPreset:selectedPreset];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleTabCommand
{
    return NO;
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleCancelCommand
{
    return [self.commandProcessor cancel];
}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
- (BOOL)handleTextInputCommand:(NSString *)text
{
    self.searchExpression = text;
    
    return [self.commandProcessor searchActionWithExpression:text];
}

@end
