<GameProjectFile>
  <PropertyGroup Type="Layer" Name="AddCommentLayer" ID="0a6c6e97-e86f-42d6-833a-46dd0f4f5133" Version="2.0.6.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="root" FrameEvent="" Tag="33" ctype="LayerObjectData">
        <Position X="0.0000" Y="0.0000" />
        <Scale ScaleX="1.0000" ScaleY="1.0000" />
        <AnchorPoint />
        <CColor A="255" R="255" G="255" B="255" />
        <Size X="1080.0000" Y="1920.0000" />
        <PrePosition X="0.0000" Y="0.0000" />
        <PreSize X="0.0000" Y="0.0000" />
        <Children>
          <NodeObjectData Name="pnlBack" ActionTag="196647326" FrameEvent="" Tag="345" ObjectIndex="2" TouchEnable="True" BackColorAlpha="127" ComboBoxIndex="1" ColorAngle="90.0000" ctype="PanelObjectData">
            <Position X="0.0000" Y="0.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <AnchorPoint />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="1080.0000" Y="1920.0000" />
            <PrePosition X="0.0000" Y="0.0000" />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="0" G="0" B="0" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </NodeObjectData>
          <NodeObjectData Name="pnlBackGround" ActionTag="-1318471696" FrameEvent="" Tag="34" ObjectIndex="1" TouchEnable="True" BackColorAlpha="102" ColorAngle="90.0000" Scale9Enable="True" Scale9Width="236" Scale9Height="409" ctype="PanelObjectData">
            <Position X="540.0000" Y="850.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="1000.0000" Y="1600.0000" />
            <PrePosition X="0.5000" Y="0.4427" />
            <PreSize X="0.9259" Y="0.8333" />
            <Children>
              <NodeObjectData Name="txtPackName" ActionTag="-1549222344" FrameEvent="" Tag="41" ObjectIndex="2" PrePositionEnabled="True" FontSize="60" LabelText="靖江王府" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ctype="TextObjectData">
                <Position X="500.0000" Y="1536.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="240.0000" Y="69.0000" />
                <PrePosition X="0.5000" Y="0.9600" />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="ttf/FZXuanZhenZhuanBianS-R-GB.TTF" />
              </NodeObjectData>
              <NodeObjectData Name="btnOK" ActionTag="-1621725990" FrameEvent="" Tag="44" ObjectIndex="3" TouchEnable="True" FontSize="36" ButtonText="确   定" Scale9Enable="True" Scale9Width="114" Scale9Height="41" ctype="ButtonObjectData">
                <Position X="763.6600" Y="113.3333" />
                <Scale ScaleX="2.0000" ScaleY="2.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="220.0000" Y="80.0000" />
                <PrePosition X="0.7637" Y="0.0708" />
                <PreSize X="0.2200" Y="0.0500" />
                <TextColor A="255" R="255" G="255" B="255" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" />
                <PressedFileData Type="Default" Path="Default/Button_Press.png" />
                <NormalFileData Type="Normal" Path="ui/image/gBtnBG.png" />
              </NodeObjectData>
              <NodeObjectData Name="txtComment" ActionTag="-2118724677" FrameEvent="" Tag="52" ObjectIndex="1" TouchEnable="True" FontSize="48" IsCustomSize="True" LabelText="" PlaceHolderText="你对景点的点评..." MaxLengthText="10" ctype="TextFieldObjectData">
                <Position X="493.3260" Y="1298.3344" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="0" G="0" B="0" />
                <Size X="900.0000" Y="300.0000" />
                <PrePosition X="0.4933" Y="0.8115" />
                <PreSize X="0.9000" Y="0.1875" />
              </NodeObjectData>
              <NodeObjectData Name="lvImage" ActionTag="1826008183" FrameEvent="" Tag="126" ObjectIndex="1" PrePositionEnabled="True" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ColorAngle="90.0000" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="10" DirectionType="Vertical" HorizontalType="Align_HorizontalCenter" VerticalType="0" ctype="ListViewObjectData">
                <Position X="500.0000" Y="210.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <AnchorPoint ScaleX="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <Size X="920.0000" Y="900.0000" />
                <PrePosition X="0.5000" Y="0.1312" />
                <PreSize X="0.9200" Y="0.5625" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </NodeObjectData>
            </Children>
            <FileData Type="Normal" Path="ui/image/bg1.png" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </NodeObjectData>
          <NodeObjectData Name="btnClose" ActionTag="1372740470" FrameEvent="" Tag="45" ObjectIndex="4" TouchEnable="True" FontSize="14" ButtonText="" Scale9Width="44" Scale9Height="46" ctype="ButtonObjectData">
            <Position X="946.3300" Y="1708.3300" />
            <Scale ScaleX="2.0000" ScaleY="2.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <CColor A="255" R="255" G="255" B="255" />
            <Size X="44.0000" Y="46.0000" />
            <PrePosition X="0.8762" Y="0.8898" />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <DisabledFileData Type="Normal" Path="ui/image/pClose.png" />
            <PressedFileData Type="Normal" Path="ui/image/pClose.png" />
            <NormalFileData Type="Normal" Path="ui/image/closed.png" />
          </NodeObjectData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameProjectFile>